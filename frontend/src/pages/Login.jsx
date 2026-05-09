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
