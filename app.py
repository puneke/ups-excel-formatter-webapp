import os
from flask import Flask, flash, render_template, request, redirect, url_for, make_response, send_file
from werkzeug.utils import secure_filename
from flask_wtf import FlaskForm
from wtforms import FileField, SubmitField
from flask_wtf.file import FileAllowed, FileRequired
from excel_formatter import standard_order, inventory_inbound
import datetime

app = Flask(__name__)

# Configuration
app.config['SECRET_KEY'] = os.urandom(24)
app.config['MAX_CONTENT_LENGTH'] = 16 * 1024 * 1024  # 16 MB
app.config['DATA_FOLDER'] = 'data'
app.config['RAW_FOLDER'] = 'data/raw'
app.config['PROCESSED_FOLDER'] = 'data/processed'
app.config['WTF_CSRF_ENABLED'] = True
app.config['TEMPLATES_AUTO_RELOAD'] = True

# Ensure upload folder exists
if not os.path.exists(app.config['DATA_FOLDER']):
    os.makedirs(app.config['DATA_FOLDER'])
    os.makedirs(app.config['RAW_FOLDER'])
    os.makedirs(app.config['PROCESSED_FOLDER'])

class UploadForm(FlaskForm):
    file = FileField('Excel File', validators=[
        FileRequired(),
        FileAllowed(['xlsx', 'xls'], 'Excel files only!')
    ])
    submit = SubmitField('Upload')

@app.errorhandler(413)

def too_large(e):
    return make_response("File is too large", 413)

def allowed_file(filename):
    return '.' in filename and \
           filename.rsplit('.', 1)[1].lower() in {'xlsx', 'xls'}

@app.route('/')
def index():
    return redirect(url_for('upload'))

@app.route('/upload', methods=['GET', 'POST'])
def upload():
    form = UploadForm()
    if form.validate_on_submit():
        file = form.file.data
        if file and allowed_file(file.filename):
            filename = secure_filename(file.filename)
            # file specific processing
            if filename == 'Standard_Order_Details_Created_for_account_99930_NZ.xlsx':
                flash('File successfully uploaded')
                raw_filepath = f'data/raw/{filename}'
                file.save(raw_filepath)
    
                processed_file = standard_order(raw_filepath)
                print(f'datetime: {datetime.datetime.now()}')
                return send_file(processed_file, as_attachment=True)

            elif filename == 'Inventory_Inbound_with_KPI_Details_NZ.xlsx':
                flash('File successfully uploaded')
                raw_filepath = f'data/raw/{filename}'
                file.save(raw_filepath)
                
                
                processed_file = inventory_inbound(raw_filepath)
                print(f'datetime: {datetime.datetime.now()}')
                return send_file(processed_file, as_attachment=True)

            else: 
                flash('Unsupported file')

            return redirect(url_for('upload'))
        else:
            flash('Invalid file type')
    return render_template('upload.html', form=form)

if __name__ == '__main__':
    app.run(debug=True)