defmodule Env do
  def new() do [] end
  def add(id,str,env) do
    [{id,str}] ++ env
  end
  def lookup(id,[{var,str}|[]]) do
    cond do
      id == var -> {id,str}
      true -> nil
    end

  end
  def lookup(id,[{var,str}|t]) do
    cond do
      id == var -> {var,str}
      true -> lookup(id,t)
    end

  end
  ###the 'e' before the variable name stands for envoirment
  ##meaning its the envoirment variables im handling
  def remove(list,env)do
    #remove(list,env,[])
    map1 = MapSet.new(env)
    map2 = MapSet.new(list)
    newEnv = MapSet.difference(map1,map2)
    MapSet.to_list(newEnv)
  end
  def remove_elem({e,_} = l,env)do
    map = MapSet.new(env)
    newEnv = MapSet.delete(map,l)
    MapSet.to_list(newEnv)

  end



end
