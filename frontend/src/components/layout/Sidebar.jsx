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
