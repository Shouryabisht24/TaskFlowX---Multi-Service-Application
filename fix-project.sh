#!/bin/bash

# TaskFlowX Project Fix Script
# Fixes missing files and import paths to enable successful Docker build

set -e

PROJECT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FRONTEND_DIR="$PROJECT_DIR/frontend"

echo "🔧 Fixing TaskFlowX project structure..."

# 1. Create AuthContext if missing
AUTH_CONTEXT="$FRONTEND_DIR/src/context/AuthContext.jsx"
if [ ! -f "$AUTH_CONTEXT" ]; then
    echo "📝 Creating AuthContext.jsx..."
    mkdir -p "$FRONTEND_DIR/src/context"
    cat > "$AUTH_CONTEXT" << 'EOF'
import { createContext, useState } from 'react';

export const AuthContext = createContext();

export function AuthProvider({ children }) {
    const [user, setUser] = useState(null);
    const [token, setToken] = useState(null);

    const login = (userData, accessToken) => {
        setUser(userData);
        setToken(accessToken);
        localStorage.setItem('token', accessToken);
    };

    const logout = () => {
        setUser(null);
        setToken(null);
        localStorage.removeItem('token');
    };

    return (
        <AuthContext.Provider value={{ user, token, login, logout }}>
            {children}
        </AuthContext.Provider>
    );
}
EOF
    echo "✓ AuthContext.jsx created at $AUTH_CONTEXT"
else
    echo "✓ AuthContext.jsx already exists"
fi

# 2. Create Register.jsx if missing
REGISTER_PAGE="$FRONTEND_DIR/src/pages/Register.jsx"
if [ ! -f "$REGISTER_PAGE" ]; then
    echo "📝 Creating Register.jsx..."
    mkdir -p "$FRONTEND_DIR/src/pages"
    cat > "$REGISTER_PAGE" << 'EOF'
import { useState, useContext } from 'react';
import { AuthContext } from '../context/AuthContext';
import { register } from '../api/authApi';
import { Link } from 'react-router-dom';

export default function Register() {
    const [form, setForm] = useState({ username: '', password: '' });
    const { login: authLogin } = useContext(AuthContext);

    const handleSubmit = async (e) => {
        e.preventDefault();
        try {
            const res = await register(form);
            authLogin(res.data.access_token);
        } catch (err) { alert("Registration Failed"); }
    };

    return (
        <div className="h-screen flex items-center justify-center bg-slate-950 text-white">
            <div className="w-full max-w-md bg-slate-900 p-8 rounded-2xl border border-slate-800 shadow-2xl">
                <h2 className="text-2xl font-bold mb-6 text-center">TaskFlow<span className="text-indigo-500">X</span> Register</h2>
                <form onSubmit={handleSubmit} className="space-y-4">
                    <input className="w-full bg-slate-800 border border-slate-700 p-3 rounded-lg outline-none focus:border-indigo-500" placeholder="Username" onChange={e => setForm({...form, username: e.target.value})} />
                    <input type="password" className="w-full bg-slate-800 border border-slate-700 p-3 rounded-lg outline-none focus:border-indigo-500" placeholder="Password" onChange={e => setForm({...form, password: e.target.value})} />
                    <button className="w-full bg-indigo-600 hover:bg-indigo-500 py-3 rounded-lg font-bold transition-all">Register</button>
                </form>
                <p className="text-center mt-6 text-slate-400 text-sm">Already have an account? <Link to="/login" className="text-indigo-400 hover:underline">Login</Link></p>
            </div>
        </div>
    );
}
EOF
    echo "✓ Register.jsx created at $REGISTER_PAGE"
else
    echo "✓ Register.jsx already exists"
fi

# 3. Create Navbar.jsx if missing with correct import path
NAVBAR="$FRONTEND_DIR/src/components/layout/Navbar.jsx"
if [ ! -f "$NAVBAR" ]; then
    echo "📝 Creating Navbar.jsx..."
    mkdir -p "$FRONTEND_DIR/src/components/layout"
    cat > "$NAVBAR" << 'EOF'
import { Link } from 'react-router-dom';
import { useContext } from 'react';
import { AuthContext } from '../../context/AuthContext';

const Navbar = () => {
    const { user, logout } = useContext(AuthContext);

    return (
        <nav className="bg-slate-900 shadow-lg">
            <div className="max-w-6xl mx-auto px-4 py-2 flex justify-between items-center">
                <h1 className="text-xl font-bold text-white">TaskFlow<span className="text-indigo-500">X</span></h1>
                {user ? (
                    <div className="flex gap-4">
                        <Link to="/dashboard" className="text-white hover:underline">Dashboard</Link>
                        <button onClick={logout} className="text-white hover:underline">Logout</button>
                    </div>
                ) : (
                    <div className="flex gap-4">
                        <Link to="/login" className="text-white hover:underline">Login</Link>
                        <Link to="/register" className="text-white hover:underline">Register</Link>
                    </div>
                )}
            </div>
        </nav>
    );
};

export default Navbar;
EOF
    echo "✓ Navbar.jsx created at $NAVBAR"
else
    echo "✓ Navbar.jsx already exists"
fi

# 4. Fix Navbar import path if it's wrong
if grep -q "from '../context/AuthContext'" "$NAVBAR"; then
    echo "🔄 Fixing Navbar.jsx import path..."
    sed -i '' "s|from '../context/AuthContext'|from '../../context/AuthContext'|g" "$NAVBAR"
    echo "✓ Navbar.jsx import path corrected"
fi

# 5. Create stub API files if missing
AUTHAPI="$FRONTEND_DIR/src/api/authApi.js"
if [ ! -f "$AUTHAPI" ]; then
    echo "📝 Creating authApi.js stub..."
    mkdir -p "$FRONTEND_DIR/src/api"
    cat > "$AUTHAPI" << 'EOF'
import axios from 'axios';

const API_BASE = process.env.REACT_APP_API_URL || 'http://localhost:8000';

export const register = (data) => {
    return axios.post(`${API_BASE}/auth/register`, data);
};

export const login = (data) => {
    return axios.post(`${API_BASE}/auth/login`, data);
};

export const logout = () => {
    localStorage.removeItem('token');
};
EOF
    echo "✓ authApi.js stub created at $AUTHAPI"
else
    echo "✓ authApi.js already exists"
fi

# 6. Fix nginx.conf if it contains events/http blocks
NGINX_CONF="$FRONTEND_DIR/nginx.conf"
if [ -f "$NGINX_CONF" ]; then
    if grep -q "^events {" "$NGINX_CONF" || grep -q "^http {" "$NGINX_CONF"; then
        echo "🔄 Fixing nginx.conf (removing events/http blocks)..."
        cat > "$NGINX_CONF" << 'EOF'
server {
    listen 80;

    root /usr/share/nginx/html;
    index index.html index.htm;

    location / {
        try_files $uri $uri/ /index.html;
    }
}
EOF
        echo "✓ nginx.conf fixed at $NGINX_CONF"
    else
        echo "✓ nginx.conf is valid"
    fi
else
    echo "📝 Creating nginx.conf..."
    cat > "$NGINX_CONF" << 'EOF'
server {
    listen 80;

    root /usr/share/nginx/html;
    index index.html index.htm;

    location / {
        try_files $uri $uri/ /index.html;
    }
}
EOF
    echo "✓ nginx.conf created at $NGINX_CONF"
fi

echo ""
echo "✅ Project fixes complete!"
echo ""
echo "Next steps:"
echo "  1. cd $PROJECT_DIR"
echo "  2. docker compose build --no-cache frontend"
echo "  3. docker compose up"
