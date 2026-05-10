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
