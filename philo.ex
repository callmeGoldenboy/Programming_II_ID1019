defmodule Chopstick do
def start do
  stick = spawn_link(fn -> available() end)
end

def available() do
  receive do
    {:request,from} ->
       send(from,:granted)
       gone()
    :quit -> :ok
  end
end

def gone() do
  receive do
    :return-> available()
    :quit -> :ok
  end
end

def request(stick) do
  send(stick, {:request,self()})
  receive do
    :granted-> :ok
  end
end
def return(stick)do
  send(stick,:return)

end
def quit(stick) do
  Process.exit(stick,:kill)
end

end
#---------the philosopher module -------------
defmodule Philosopher do
  def start(name,hunger,right,left,main) do
     spawn_link(fn->philo(name,hunger,right,left,main)end)
  end
  def philo(name,hunger,right,left,main)do
    dreaming(name,hunger,right,left,main)
  end

  def dreaming(name,0,right,left,main)do
    IO.puts("#{name} is no longer hungry...")
    send(main,:done)
  end
  def dreaming(name,hunger,right,left,main) do
    IO.puts("#{name} is peacfully dreaming...")
    #sleep(1000)
    waiting(name,hunger,right,left,main)
  end

  ###----the waiting state
  def waiting(name,hunger,right,left,main)do
    #send(main,:waiting)
     IO.puts("#{name} is waiting for chopsticks...")
    case Chopstick.request(left) do
      :ok -> IO.puts("#{name} has recevied the left chopstick...")
      #_-> waiting(name,hunger,right,left,main)
      case Chopstick.request(right) do
        :ok ->
          #send(main,:recevied)
          IO.puts("#{name} has now recieved both chopsticks..")
          eating(name,hunger,right,left,main)
          send(main,:done)
      end
    end
  end

  #-----the eating state
  def eating(name,hunger,right,left,main)do
    IO.puts("#{name} is now eating...")
    sleep(1000)    #sleep is here used as a timer for how long the philosopher is eating
    #send(main,:done)
    Chopstick.return(left)
    Chopstick.return(right)
    dreaming(name,hunger - 1,right,left,main)
  end

  def sleep(t) do
  :timer.sleep(t)
  end
end
  #------------Dinner module --------------
defmodule Dinner do
def start(), do: spawn(fn -> init() end)

def init() do
  c1 = Chopstick.start()
  c2 = Chopstick.start()
  c3 = Chopstick.start()
  c4 = Chopstick.start()
  c5 = Chopstick.start()
  ctrl = self()
  Philosopher.start("Natan",5,c1,c2,ctrl)
  Philosopher.start("Djiko",5,c1,c2,ctrl)
  Philosopher.start("Amar",5,c1,c2,ctrl)
  Philosopher.start("Omid",5,c1,c2,ctrl)
  Philosopher.start("Ele",5,c1,c2,ctrl)
  wait(5, [c1, c2, c3, c4, c5])
end
def wait(0, chopsticks) do
  Enum.each(chopsticks, fn(c) -> Chopstick.quit(c) end)
  IO.puts("Everybody's belly is now full and they can now go on with their lives")
end

def wait(n, chopsticks) do
  receive do
    :done ->
      wait(n - 1, chopsticks)
    :abort ->
      Process.exit(self(), :kill)
  end
end

end
