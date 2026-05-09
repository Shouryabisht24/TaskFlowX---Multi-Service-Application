export default function TaskCard({ task }) {
    return (
        <div className="bg-slate-900 p-5 rounded-lg border border-slate-800 hover:border-indigo-500 transition-all">
            <div className="flex justify-between items-start mb-3">
                <h3 className="font-bold text-lg text-white">{task.title}</h3>
                <span className={`text-xs px-2 py-1 rounded ${task.completed ? 'bg-green-900 text-green-300' : 'bg-amber-900 text-amber-300'}`}>
                    {task.completed ? 'Deployed' : 'Pending'}
                </span>
            </div>
            <p className="text-slate-400 text-sm mb-4">{task.description}</p>
        </div>
    );
}
