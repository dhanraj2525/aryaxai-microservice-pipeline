from fastapi import FastAPI

app = FastAPI()

# This is a sample API endpoint
@app.get("/")
def read_root():
    return {"message": "Hello, World!"}
