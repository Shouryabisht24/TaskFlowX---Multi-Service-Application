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
