
// ThreadPool class offers the ability to queue up Runnable tasks to be 
// executed by a free thread if one is available. If the queue is empty
// the threads will sleep on a Condition in the workqueue, the workqueue
// itself will notify the sleepers itself when more work arrives.

module sendero.util.ThreadPool;

import tango.core.Thread;
public import sendero.util.WorkQueue;
import tango.core.Exception;
import tango.io.Console;
import tango.io.Stdout;

class ThreadPool
{
  private WorkQueue wqueue;
	private PoolWorker[] workers;
	private int num_workers;
  bool running;
	this(int nthreads)
	{ 
		running = true;
		num_workers = nthreads;
		wqueue = new WorkQueue;
		workers = new PoolWorker[nthreads];
   
		foreach (wk; workers)
		{
			wk = new PoolWorker();
			wk.start();
		}
	}

	public void add_task(Task t)
	{
		wqueue.pushBack(t);
	}

	public void wait()
	{
		foreach(wk; workers)
		{
			wk.join();
		}
	}

	public void end()
	{
		running = false;
	}

	class PoolWorker : Thread 
	{
		this ()
		{
			super(&run);
		}

		private
		void run() 
		{
			Stdout.formatln("Starting thread");
			while(running)
			{
				//WorkQueue is built for threaded access and will block on empty
				//so this thread simply needs to request a task and will block(sleep)
				//until one becomes available
				Task task = wqueue.popFront();
				try
   			{
					task();
				}
				catch(Exception e)
				{
					Cout(e);
				}
			}
		}	
	}
}
