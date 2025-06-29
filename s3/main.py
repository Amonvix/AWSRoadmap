from fastapi import FastAPI, UploadFile, HTTPException
from fastapi.responses import JSONResponse
from storage_s3 import (
    upload_file_to_s3,
    list_files_in_s3,
    delete_file_from_s3,
    create_bucket_if_not_exists,
)

app = FastAPI(title="S3 Integration API", version="1.0")


@app.on_event("startup")
async def startup_event():
    print(create_bucket_if_not_exists())


@app.post("/upload")
async def upload_file(file: UploadFile):
    result = upload_file_to_s3(file)
    if "failed" in result.lower():
        raise HTTPException(status_code=500, detail=result)
    return JSONResponse(content={"message": result})


@app.get("/files")
async def get_files():
    files = list_files_in_s3()
    return {"files": files}


@app.delete("/files/{filename}")
async def delete_file(filename: str):
    result = delete_file_from_s3(filename)
    if "failed" in result.lower():
        raise HTTPException(status_code=500, detail=result)
    return JSONResponse(content={"message": result})
