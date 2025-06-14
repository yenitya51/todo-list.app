<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Todo;

class TodoController extends Controller
{
    public function index(Request $request)
    {
        return Todo::where('user_id', $request->user()->id)
            ->orderByRaw("FIELD(priority, 'high', 'medium', 'low')")
            ->orderBy('due_date')
            ->get();
    }

    public function store(Request $request)
    {
        $data = $request->validate([
            'title'       => 'required|string',
            'description' => 'nullable|string',
            'priority'    => 'required|in:low,medium,high',
            'due_date'    => 'required|date|after_or_equal:today',
        ]);

        $data['user_id'] = $request->user()->id;
        $data['is_done'] = false;

        $todo = Todo::create($data);
        return response()->json($todo, 201);
    }

    public function update(Request $request, $id)
    {
        $todo = Todo::where('id', $id)->where('user_id', $request->user()->id)->firstOrFail();

        $data = $request->validate([
            'title'       => 'sometimes|required|string',
            'description' => 'nullable|string',
            'priority'    => 'in:low,medium,high',
            'due_date'    => 'nullable|date|after_or_equal:today',
            'is_done'     => 'boolean',
        ]);

        $todo->update($data);

        return response()->json($todo);
    }

    public function destroy(Request $request, $id)
    {
        $todo = Todo::where('id', $id)->where('user_id', $request->user()->id)->firstOrFail();
        $todo->delete();

        return response()->json(['message' => 'Tugas berhasil dihapus']);
    }
}
