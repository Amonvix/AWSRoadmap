import boto3
import os
from app.models import FormResponse
from dotenv import load_dotenv

load_dotenv()

dynamodb = boto3.resource(
    'dynamodb',
    region_name='us-east-1',
    aws_access_key_id=os.getenv("AWS_ACCESS_KEY_ID"),
    aws_secret_access_key=os.getenv("AWS_SECRET_ACCESS_KEY")
)

table = dynamodb.Table("smartform_submissions")

def save_form_data(data: FormResponse):
    item = data.dict()
    table.put_item(Item=item)
