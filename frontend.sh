#!/bin/bash

# 1. Create the main project directory
mkdir -p frontend
cd frontend

# 2. Create Folder Structure
mkdir -p src/api src/components/layout src/components/ui src/context src/pages

# 3. Create package.json (ESSENTIAL for Docker build)
cat <<EOF > package.json
{
  "name": "frontend",
  "private": true,
  "version": "0.0.0",
  "type": "module",
  "scripts": {
    "dev": "vite",
    "build": "vite build",
    "preview": "vite preview"
  },
  "dependencies": {
    "axios": "^1.6.0",
    "lucide-react": "^0.292.0",
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "react-router-dom": "^6.20.0"
  },
  "devDependencies": {
    "@types/react": "^18.2.0",
    "@types/react-dom": "^18.2.0",
    "@vitejs/plugin-react": "^4.2.0",
    "autoprefixer": "^10.4.16",
    "postcss": "^8.4.31",
    "tailwindcss": "^3.3.5",
    "vite": "^5.0.0"
  }
}
EOF

# 4. Create index.html (ESSENTIAL for Vite)
cat <<EOF > index.html
<!doctype html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>TaskFlowX</title>
  </head>
  <body>
    <div id="root"></div>
    <script type="module" src="/src/main.jsx"></script>
  </body>
</html>
EOF

# 5. Create vite.config.js (ESSENTIAL for Build)
cat <<EOF > vite.config.js
import { defineConfig } from 'vite'
import react from '@vitejs/plugin-react'

export default defineConfig({
  plugins: [react()],
})
EOF

# 6. Create .env
cat <<EOF > .env
VITE_AUTH_SERVICE_URL=http://localhost:8000
VITE_TASK_SERVICE_URL=http://localhost:8081
EOF

# 7. Create Tailwind Config
cat <<EOF > tailwind.config.js
/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {},
  },
  plugins: [],
}
EOF

# 8. Create API Layer
cat <<EOF > src/api/axiosConfig.js
import axios from 'axios';
const api = axios.create();
api.interceptors.request.use((config) => {
    const token = localStorage.getItem('token');
    if (token) config.headers.Authorization = \`Bearer \${token}\`;
    return config;
}, (error) => Promise.reject(error));
export default api;
EOF

cat <<EOF > src/api/authApi.js
import api from './axiosConfig';
export const login = (data) => api.post(\`\${import.meta.env.VITE_AUTH_SERVICE_URL}/auth/login\`, data);
export const register = (data) => api.post(\`\${import.meta.env.VITE_AUTH_SERVICE_URL}/auth/register\`, data);
EOF

cat <<EOF > src/api/taskApi.js
import api from './axiosConfig';
export const fetchTasks = () => api.get(\`\${import.meta.env.VITE_TASK_SERVICE_URL}/api/tasks\`);
export const createHask = (data) => api.post(\`\${import.meta.env.VITE_TASK_SERVICE_URL}/api/tasks\`, data);
EOF

# 9. Create Context
cat <<EOF > src/context/AuthContext.jsx
import { createContext, useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';

export const AuthContext = createContext();

export const AuthProvider = ({ children }) => {
    const [user, setUser] = useState(null);
    const [loading, setLoading] = useState(true);
    const navigate = useNavigate();

    useEffect(() => {
        const token = localStorage.getItem('token');
        if (token) setUser({ token });
        setLoading(false);
    }, []);

    const login = (token) => {
        localStorage.setItem('token', token);
        setUser({ token });
        navigate('/dashboard');
    };

    const logout = () => {
        localStorage.removeItem('token');
        setUser(null);
        navigate('/login');
    };

    return (
        <AuthContext.Provider value={{ user, login, logout, loading }}>
            {children}
        </AuthContext.Provider>
    );
};
EOF

# 10. Create Components
cat <<EOF > src/components/layout/Sidebar.jsx
import { Link } from 'react-router-dom';
import { LayoutDashboard, LogOut, CheckSquare } from 'lucide-react';

export default function Sidebar() {
    return (
        <div className="w-64 bg-slate-900 border-r border-slate-800 flex flex-col">
            <div className="p-6 text-xl font-bold text-white">
                TaskFlow<span className="text-indigo-500">X</span>
            </div>
            <nav className="flex-1 px-4 space-y-2">
                <Link to="/dashboard" className="flex items-center gap-3 p-3 rounded-lg text-slate-400 hover:bg-slate-800 hover:text-white transition-all">
                    <LayoutDashboard size={20} /> Dashboard
                </Link>
                <Link to="/tasks" className="flex items-center gap-3 p-3 rounded-lg text-slate-400 hover:bg-slate-800 hover:text-white transition-all">
                    <CheckSquare size={20} /> My Tasks
                </Link>
            </nav>
            <div className="p-4 border-t border-slate-800">
                <button onClick={() => {localStorage.clear(); window.location.href='/login'}} className="flex items-center gap-3 p-3 w-full text-red-400 hover:bg-red-900/20 rounded-lg transition-all">
                    <LogOut size={20} /> Logout
                </button>
            </div>
        </div>
    );
}
EOF

cat <<EOF > src/components/ui/TaskCard.jsx
export default function TaskCard({ task }) {
    return (
        <div className="bg-slate-900 p-5 rounded-lg border border-slate-800 hover:border-indigo-500 transition-all">
            <div className="flex justify-between items-start mb-3">
                <h3 className="font-bold text-lg text-white">{task.title}</h3>
                <span className={\`text-xs px-2 py-1 rounded \${task.completed ? 'bg-green-900 text-green-300' : 'bg-amber-900 text-amber-300'}\`}>
                    {task.completed ? 'Deployed' : 'Pending'}
                </span>
            </div>
            <p className="text-slate-400 text-sm mb-4">{task.description}</p>
        </div>
    );
}
EOF

# 11. Create Pages
cat <<EOF > src/pages/Login.jsx
import { useState, useContext } from 'react';
import { AuthContext } from '../context/AuthContext';
import { login } from '../api/authApi';
import { Link } from 'react-router-dom';

export default function Login() {
    const [form, setForm] = useState({ username: '', password: '' });
    const { login: authLogin } = useContext(AuthContext);

    const handleSubmit = async (e) => {
        e.preventDefault();
        try {
            const res = await login(form);
            authLogin(res.data.access_token);
        } catch (err) { alert("Invalid Credentials"); }
    };

    return (
        <div className="h-screen flex items-center justify-center bg-slate-950 text-white">
            <div className="w-full max-w-md bg-slate-900 p-8 rounded-2xl border border-slate-800 shadow-2xl">
                <h2 className="text-2xl font-bold mb-6 text-center">TaskFlow<span className="text-indigo-500">X</span> Login</h2>
                <form onSubmit={handleSubmit} className="space-y-4">
                    <input className="w-full bg-slate-800 border border-slate-700 p-3 rounded-lg outline-none focus:border-indigo-500" placeholder="Username" onChange={e => setForm({...form, username: e.target.value})} />
                    <input type="password" className="w-full bg-slate-800 border border-slate-700 p-3 rounded-lg outline-none focus:border-indigo-500" placeholder="Password" onChange={e => setForm({...form, password: e.target.value})} />
                    <button className="w-full bg-indigo-600 hover:bg-indigo-500 py-3 rounded-lg font-bold transition-all">Enter Dashboard</button>
                </form>
                <p className="text-center mt-6 text-slate-400 text-sm">New here? <Link to="/register" className="text-indigo-400 hover:underline">Create an account</Link></p>
            </div>
        </div>
    );
}
EOF

cat <<EOF > src/pages/Dashboard.jsx
import { useEffect, useState } from 'react';
import { fetchTasks, createHask } from '../api/taskApi';
import TaskCard from '../components/ui/TaskCard';
import Sidebar from '../components/layout/Sidebar';

export default function Dashboard() {
    const [tasks, setTasks] = useState([]);
    const [newTask, setNewTask] = useState({ title: '', description: '' });
    const [loading, setLoading] = useState(true);

    useEffect(() => { loadTasks(); }, []);

    const loadTasks = async () => {
        try { const res = await fetchTasks(); setTasks(res.data); }
        catch (err) { console.error("Error"); }
        finally { setLoading(false); }
    };

    const handleAddTask = async (e) => {
        e.preventDefault();
        try { await createHask(newTask); setNewTask({ title: '', description: '' }); loadTasks(); }
        catch (err) { alert("Error"); }
    };

    return (
        <div className="flex h-screen bg-slate-950 text-slate-200">
            <Sidebar />
            <main className="flex-1 overflow-y-auto p-8">
                <header className="flex justify-between items-center mb-8">
                    <h1 className="text-3xl font-bold text-white">Task <span className="text-indigo-500">FlowX</span></h1>
                    <div className="text-sm text-slate-400 bg-slate-900 px-3 py-1 rounded-full border border-slate-800">System: <span className="text-green-500">Online</span></div>
                </header>
                <section className="bg-slate-900 p-6 rounded-xl border border-slate-800 mb-10">
                    <form onSubmit={handleAddTask} className="grid grid-cols-1 md:grid-cols-3 gap-4">
                        <input className="bg-slate-800 border border-slate-700 p-2 rounded text-white" placeholder="Task Title" value={newTask.title} onChange={e => setNewTask({...newTask, title: e.target.value})} required />
                        <input className="bg-slate-800 border border-slate-700 p-2 rounded text-white" placeholder="Description" value={newTask.description} onChange={e => setNewTask({...newTask, description: e.target.value})} />
                        <button className="bg-indigo-600 hover:bg-indigo-500 text-white font-bold py-2 px-4 rounded">+ Create Task</button>
                    </form>
                </section>
                <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
                    {loading ? <p>Loading...</p> : tasks.map(task => <TaskCard key={task.id} task={task} />)}
                </div>
            </main>
        </div>
    );
}
EOF

# 12. App.jsx and Main.jsx
cat <<EOF > src/App.jsx
import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom';
import { AuthProvider, AuthContext } from './context/AuthContext';
import { useContext } from 'react';
import Login from './pages/Login';
import Dashboard from './pages/Dashboard';

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
                    <Route path="/" element={<Navigate to="/dashboard" />} />
                </Routes>
            </AuthProvider>
        </Router>
    );
}
export default App;
EOF

cat <<EOF > src/main.jsx
import React from 'react'
import ReactDOM from 'react-dom/client'
import App from './App.jsx'
import './index.css'

ReactDOM.createRoot(document.getElementById('root')).render(
  <React.StrictMode>
    <App />
  </React.StrictMode>,
)
EOF

# 13. index.css for Tailwind
cat <<EOF > src/index.css
@tailwind base;
@tailwind components;
@tailwind utilities;
EOF


echo "✅ Pure files generated successfully in taskflowx-frontend/"
echo "👉 You can now build your Docker image directly."
