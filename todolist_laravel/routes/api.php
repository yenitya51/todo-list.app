<?php
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\TodoController;
use App\Http\Middleware\AuthTokenMiddleware;


Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);

Route::middleware([AuthTokenMiddleware::class])->post('/logout', [AuthController::class, 'logout']);


Route::middleware([AuthTokenMiddleware::class])->group(function () {
    Route::get('/todos', [TodoController::class, 'index']);        
    Route::post('/todos', [TodoController::class, 'store']);       
    Route::put('/todos/{id}', [TodoController::class, 'update']);  
    Route::delete('/todos/{id}', [TodoController::class, 'destroy']); 
});
