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
        {:ok, ts} ->
          {str,ts}
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
    {_, _} ->
      :fail
  end
end

end
