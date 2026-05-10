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
