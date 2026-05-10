import { useState, useContext } from 'react';
import { AuthContext } from '../context/AuthContext';
import { register } from '../api/authApi';
import { Link } from 'react-router-dom';

export default function Register() {
    const [form, setForm] = useState({ username: '', password: '' });
    const [loading, setLoading] = useState(false);
    const [error, setError] = useState('');
    const { login: authLogin } = useContext(AuthContext);

    const handleSubmit = async (e) => {
        e.preventDefault();
        setLoading(true);
        setError('');
        console.log('Registering with:', form);
        try {
            const res = await register(form);
            console.log('Registration response:', res);
            authLogin(res.data.access_token);
            alert("Registration successful!");
        } catch (err) {
            console.error('Registration error:', err.response?.data || err.message);
            setError(err.response?.data?.detail || "Registration Failed");
            alert("Registration Failed: " + (err.response?.data?.detail || err.message));
        } finally {
            setLoading(false);
        }
    };

    return (
        <div className="h-screen flex items-center justify-center bg-slate-950 text-white">
            <div className="w-full max-w-md bg-slate-900 p-8 rounded-2xl border border-slate-800 shadow-2xl">
                <h2 className="text-2xl font-bold mb-6 text-center">TaskFlow<span className="text-indigo-500">X</span> Register</h2>
                <form onSubmit={handleSubmit} className="space-y-4">
                    <input className="w-full bg-slate-800 border border-slate-700 p-3 rounded-lg outline-none focus:border-indigo-500" placeholder="Username" value={form.username} onChange={e => setForm({...form, username: e.target.value})} />
                    <input type="password" className="w-full bg-slate-800 border border-slate-700 p-3 rounded-lg outline-none focus:border-indigo-500" placeholder="Password" value={form.password} onChange={e => setForm({...form, password: e.target.value})} />
                    {error && <div className="text-red-400 text-sm">{error}</div>}
                    <button disabled={loading} className="w-full bg-indigo-600 hover:bg-indigo-500 py-3 rounded-lg font-bold transition-all">{loading ? 'Registering...' : 'Register'}</button>
                </form>
                <p className="text-center mt-6 text-slate-400 text-sm">Already have an account? <Link to="/login" className="text-indigo-400 hover:underline">Login</Link></p>
            </div>
        </div>
    );
}
