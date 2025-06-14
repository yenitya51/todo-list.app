<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\User;
use Illuminate\Support\Facades\Hash; 
use Illuminate\Support\Str;

class AuthController extends Controller
{
    public function register(Request $request)
{
    $data = $request->validate([
        'name'     => 'required|string|max:255',
        'email'    => 'required|email|unique:users',
        'password' => 'required|min:6',
    ]);

    $token = Str::random(60);

    $user = User::create([
        'name'      => $data['name'],
        'email'     => $data['email'],
        'password'  => bcrypt($data['password']),
        'api_token' => $token,
    ]);

    return response()->json(['token' => $token], 201);
}


    public function login(Request $request)
    {
        $data = $request->only('email', 'password');
        $user = User::where('email', $data['email'])->first();

        if (!$user || !Hash::check($data['password'], $user->password)) {
            return response()->json(['message' => 'Login gagal'], 401);
        }

        $token = Str::random(60);
        $user->update(['api_token' => $token]);

        return response()->json(['token' => $token]);
    }

    public function logout(Request $request)
{
    $user = $request->user();

   
    $user->api_token = null;
    $user->save();

    return response()->json(['message' => 'Logout berhasil']);
}

}
