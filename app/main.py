from fastapi import FastAPI

app = FastAPI(
    title="AryaXAI API",
    description="A simple FastAPI application",
    version="1.0.0",
)


@app.get("/")
async def root():
    return {"message": "Hello, World!"}