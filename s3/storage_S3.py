import boto3
from botocore.exceptions import ClientError
import logging
from fastapi import UploadFile
import os

# Load configs
AWS_ACCESS_KEY_ID = os.getenv("AWS_ACCESS_KEY_ID")
AWS_SECRET_ACCESS_KEY = os.getenv("AWS_SECRET_ACCESS_KEY")
AWS_REGION = os.getenv("AWS_REGION", "us-east-1")
S3_BUCKET_NAME = os.getenv("S3_BUCKET_NAME")

# S3 client
s3_client = boto3.client(
    "s3",
    region_name=AWS_REGION,
    aws_access_key_id=AWS_ACCESS_KEY_ID,
    aws_secret_access_key=AWS_SECRET_ACCESS_KEY,
)

def upload_file_to_s3(file: UploadFile) -> str:
    """Uploads a file object to S3 bucket."""
    try:
        s3_client.upload_fileobj(
            file.file,
            S3_BUCKET_NAME,
            file.filename,
            ExtraArgs={"ContentType": file.content_type}
        )
        return f"File '{file.filename}' uploaded successfully."
    except ClientError as e:
        logging.error(e)
        return f"Upload failed: {str(e)}"

def list_files_in_s3() -> list:
    """Lists all objects in the S3 bucket."""
    try:
        response = s3_client.list_objects_v2(Bucket=S3_BUCKET_NAME)
        contents = response.get("Contents", [])
        return [obj["Key"] for obj in contents]
    except ClientError as e:
        logging.error(e)
        return []

def delete_file_from_s3(filename: str) -> str:
    """Deletes a file from the S3 bucket."""
    try:
        s3_client.delete_object(Bucket=S3_BUCKET_NAME, Key=filename)
        return f"File '{filename}' deleted successfully."
    except ClientError as e:
        logging.error(e)
        return f"Deletion failed: {str(e)}"
    
def create_bucket_if_not_exists():
    """Creates the S3 bucket if it doesn't already exist."""
    try:
        existing_buckets = s3_client.list_buckets()
        bucket_names = [bucket["Name"] for bucket in existing_buckets.get("Buckets", [])]

        if S3_BUCKET_NAME not in bucket_names:
            if AWS_REGION == "us-east-1":
                s3_client.create_bucket(Bucket=S3_BUCKET_NAME)
            else:
                s3_client.create_bucket(
                    Bucket=S3_BUCKET_NAME,
                    CreateBucketConfiguration={"LocationConstraint": AWS_REGION},
                )
            return f"Bucket '{S3_BUCKET_NAME}' created successfully."
        else:
            return f"Bucket '{S3_BUCKET_NAME}' already exists."
    except ClientError as e:
        logging.error(e)
        return f"Bucket creation failed: {str(e)}"

