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
