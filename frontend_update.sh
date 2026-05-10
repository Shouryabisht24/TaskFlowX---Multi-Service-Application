#!/bin/bash

# 1. Navigate to the frontend directory
cd frontend

# 2. Add Register Page
cat <<EOF > src/pages/Register.jsx
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
                    <input className="w-full bg-slate-800 border border-slate-700 p-3 rounded-lg outline-none focus:border-indigo-500" placeholder="Username" onChange={e
=> setForm({...form, username: e.target.value})} />
                    <input type="password" className="w-full bg-slate-800 border border-slate-700 p-3 rounded-lg outline-none focus:border-indigo-500"
placeholder="Password" onChange={e => setForm({...form, password: e.target.value})} />
                    <button className="w-full bg-indigo-600 hover:bg-indigo-500 py-3 rounded-lg font-bold transition-all">Register</button>
                </form>
                <p className="text-center mt-6 text-slate-400 text-sm">Already have an account? <Link to="/login" className="text-indigo-400
hover:underline">Login</Link></p>
            </div>
        </div>
    );
}
EOF

# 3. Update App.jsx to Include Register Route
cat <<EOF > src/App.jsx
import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom';
import { AuthProvider, AuthContext } from './context/AuthContext';
import { useContext } from 'react';
import Login from './pages/Login';
import Dashboard from './pages/Dashboard';
import Register from './pages/Register';

const ProtectedRoute = ({ children }) => {
    const { user, loading } = useContext(AuthContext);
    if (loading) return <div className="h-screen bg-slate-950 text-white flex items-center justify-center">Loading...</div>;
    return user ? children : <Navigate to="/login" />;
};

function App() {
    return (
        <Router>
            <AuthProvider>
                <Routes>
                    <Route path="/login" element={<Login />} />
                    <Route path="/dashboard" element={<ProtectedRoute><Dashboard /></ProtectedRoute>} />
                    <Route path="/register" element={<Register />} />
                    <Route path="/" element={<Navigate to="/dashboard" />} />
                </Routes>
            </AuthProvider>
        </Router>
    );
}
export default App;
EOF

# 4. Add Navigation Bar Component
cat <<EOF > src/components/layout/Navbar.jsx
import { Link } from 'react-router-dom';
import { useContext } from 'react';
import { AuthContext } from '../context/AuthContext';

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

# 5. Update Dashboard Page with Navigation
cat <<EOF > src/pages/Dashboard.jsx
import { useContext } from 'react';
import { AuthContext } from '../context/AuthContext';
import Navbar from '../components/layout/Navbar';

const Dashboard = () => {
    const { user } = useContext(AuthContext);

    return (
        <div className="flex flex-col h-screen">
            <Navbar />
            <div className="p-4">
                <h1 className="text-3xl font-bold text-white mb-4">Welcome, {user.username}!</h1>
                <p>Your tasks go here.</p>
            </div>
        </div>
    );
};

export default Dashboard;
EOF

# 6. Add Footer Component
cat <<EOF > src/components/ui/Footer.jsx
import { Link } from 'react-router-dom';

const Footer = () => {
    return (
        <footer className="bg-slate-900 text-center py-4">
            <p className="text-white">&copy; 2023 TaskFlow<span className="text-indigo-500">X</span>. All rights reserved.</p>
            <nav className="mt-2">
                <ul className="flex gap-4 justify-center">
                    <li><Link to="/about" className="text-white hover:underline">About</Link></li>
                    <li><Link to="/contact" className="text-white hover:underline">Contact</Link></li>
                </ul>
            </nav>
        </footer>
    );
};

export default Footer;
EOF

# 7. Update Dashboard Page with Footer
cat <<EOF > src/pages/Dashboard.jsx
import { useContext } from 'react';
import { AuthContext } from '../context/AuthContext';
import Navbar from '../components/layout/Navbar';
import Footer from '../components/ui/Footer';

const Dashboard = () => {
    const { user } = useContext(AuthContext);

    return (
        <div className="flex flex-col min-h-screen">
            <Navbar />
            <main className="p-4 flex-1">
                <h1 className="text-3xl font-bold text-white mb-4">Welcome, {user.username}!</h1>
                <p>Your tasks go here.</p>
            </main>
            <Footer />
        </div>
    );
};

export default Dashboard;
EOF

# 8. Customize Tailwind Configuration
cat <<EOF > tailwind.config.js
module.exports = {
    content: [
        "./src/**/*.{js,jsx,ts,tsx}",
    ],
    theme: {
        extend: {
            colors: {
                'indigo-500': '#4c6ef5',
                'indigo-400': '#6d78e1',
            },
            spacing: {
                '12rem': '30rem',
            }
        },
    },
    plugins: [],
}
EOF

# 11. Add Tailwind to CSS File
cat <<EOF > src/index.css
@tailwind base;
@tailwind components;
@tailwind utilities;
EOF

# 12. Update App.jsx to Use Navbar and Footer
cat <<EOF > src/App.jsx
import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom';
import { AuthProvider, AuthContext } from './context/AuthContext';
import { useContext } from 'react';
import Login from './pages/Login';
import Dashboard from './pages/Dashboard';
import Register from './pages/Register';
import Navbar from './components/layout/Navbar';
import Footer from './components/ui/Footer';

const ProtectedRoute = ({ children }) => {
    const { user, loading } = useContext(AuthContext);
    if (loading) return <div className="h-screen bg-slate-950 text-white flex items-center justify-center">Loading...</div>;
    return user ? children : <Navigate to="/login" />;
};

function App() {
    return (
        <Router>
            <AuthProvider>
                <Navbar />
                <Routes>
                    <Route path="/login" element={<Login />} />
                    <Route path="/dashboard" element={<ProtectedRoute><Dashboard /></ProtectedRoute>} />
                    <Route path="/register" element={<Register />} />
                    <Route path="/" element={<Navigate to="/dashboard" />} />
                </Routes>
                <Footer />
            </AuthProvider>
        </Router>
    );
}
export default App;
EOF