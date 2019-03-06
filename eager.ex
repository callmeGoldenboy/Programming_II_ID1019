defmodule Eager do

  def eval_expr({:atm, id}, _) do {:ok, id} end

  def eval_expr({:var, id}, env) do
  case Env.lookup(id,env) do
    nil ->
      :error
    {_, str} ->
      {:ok,str}
  end
end
#######first evaluate the first argument in our "tuple" and if that is
###in the envoirment then evaluate the second argument in the "tuple"
###when both are in the envoirment return an elixir tuple containing the values
def eval_expr({:cons, first, second}, env) do
  case eval_expr(first, env) do
    :error ->
      :error
    {:ok,str} ->
      case eval_expr(second, env) do
        :error ->
          :error
        {:ok, str2} ->
          {:ok,{str,str2}}
      end
  end
end
def eval_match(:ignore, first, env) do
  {:ok, env}
end

def eval_match({:atm, id}, id , env) do
  {:ok, env}
end
####pattern matching for variables. if the variabel with the given value doesnt exist in the envoirment
###add it, otherwise return the envoirment. Cannot change the value of a variable inside an envoirment after it was created
def eval_match({:var, id}, str, env) do
  case Env.lookup(id,env) do
    nil ->
      {:ok, Env.add(id,str,env)}
    {_, ^str} ->
      {:ok,env}
    {id, _} ->
      :fail
  end
end
#######evaluating patternmatch for cons
def eval_match({:cons, first, second}, {:cons,{_,val},{_,val2}}, []) do
  {_,newEnv} = eval_match(first,val,[])
  {_,newEnv} = eval_match(second,val2,newEnv)
  newEnv

end
def eval_match({:cons, first, second}, {:cons,{_,val},{_,val2}}, env) do
  case eval_match(first, val, env) do
    :fail ->
      :fail
    {:ok,newenvoirment} ->
      case eval_match(second,val2, newenvoirment) do
        :fail -> :fail
        {:ok,newEnv} -> {:ok,newEnv}

      end
  end
end
def eval_match(_, _, _) do
  :fail
end
########Evaluating sequences
def eval_seq([exp], env) do
  eval_expr(exp,env)
end
def eval()  do
  seq = [{:match, {:var, :x}, {:atm,:a}},
        {:match, {:var, :y}, {:cons, {:var, :x}, {:atm, :b}}},
        {:match, {:cons, :ignore, {:var, :z}}, {:var, :y}},
        {:var, :z}]
  eval_seq(seq,Env.new())
end
def eval_seq([{:match,firstE, secondE} | exp], env) do
  ##evaluating the second part of the match and then extract the variables
  ##that contain the value of the first part to then remove them from the envoirement
  ##we then check if firstE can patter match with str (the structure returned in the outer case)
  ##if it does then create a new envoirment and recursivly call
  case eval_expr(secondE, env) do
    :error ->
      :error
    {:ok,str} ->
      vars = extract_vars(firstE)
      env2 = Env.remove(vars, env)

      case eval_match(firstE, str, env2) do
        :fail ->
          :error2
        {:ok, newEnv} ->
          eval_seq(exp, newEnv)
      end
  end
end
#####extract_vars returns a list of patterns
def extract_vars(pattern) do
  extract_vars(pattern,[])

end
def extract_vars({:atm,var}, vars) do
vars
end
def extract_vars(:ignore, vars) do vars end
def extract_vars({:var,var}, vars) do [var | vars] end
def extract_vars({:cons,head,tail},vars) do extract_vars(tail,extract_vars(head,vars)) end
######evaluating case exptressions###########

end
