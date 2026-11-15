
import mysql.connector
from flask_login import LoginManager
from flask_wtf.csrf import CSRFProtect
from config import Config

# Flask Login Manager
login_manager = LoginManager()
login_manager.login_view = "auth.login"
login_manager.login_message = "Please log in to access this page."

# CSRF Protection
csrf = CSRFProtect()


# MySQL Database Connection
def get_db_connection():
    return mysql.connector.connect(
        host=Config.MYSQL_HOST,
        user=Config.MYSQL_USER,
        password=Config.MYSQL_PASSWORD,
        database=Config.MYSQL_DATABASE
    )
