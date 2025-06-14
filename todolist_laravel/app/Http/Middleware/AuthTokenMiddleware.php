<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use App\Models\User;

class AuthTokenMiddleware
{
    public function handle(Request $request, Closure $next)
    {
        $token = $request->header('Authorization');

        if (!$token || !str_starts_with($token, 'Bearer ')) {
            return response()->json(['message' => 'Token tidak ditemukan'], 401);
        }

        $plainToken = substr($token, 7);
        $user = User::where('api_token', $plainToken)->first();

        if (!$user) {
            return response()->json(['message' => 'Token tidak valid'], 401);
        }

        
        $request->setUserResolver(function () use ($user) {
            return $user;
        });

        return $next($request);
    }
}
