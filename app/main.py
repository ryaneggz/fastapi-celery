from fastapi import FastAPI
from app.worker import test_task, celery_app

app = FastAPI()

@app.post("/task")
def create_task(x: int, y: int):
    task = test_task.delay(x, y)
    result = task.get(timeout=10)  # Wait for the task to complete, with a timeout
    return {
        "id": task.id,
        "result": result,
    }

@app.get("/task/{task_id}")
def get_task_result(task_id: str):
    task_result = celery_app.AsyncResult(task_id)

    if task_result.ready():
        return {"task_id": task_id, "status": task_result.status, "result": task_result.result}
    else:
        return {"task_id": task_id, "status": "Processing"}
