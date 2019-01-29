defmodule Huff do
  def sample do
'the quick brown fox jumps over the lazy dog
this is a sample text that we will use when we build
up a table we will only handle lower case letters and
no punctuation symbols the frequency will of course not
represent english but it is probably not that far off'
end
def text() do
'this is something that we should encode'
end
def test do
sample = sample()
tree = tree(sample)
encode = encode_table(tree)
decode = decode_table(tree)
text = text()
seq = encode(text, encode)
decode(seq, decode)
end
def tree(sample) do
  freq = freq(sample)
  tree = isort(freq)
  huffmantree(tree)
end
def huffmantree(sorted) do
  build_tree(sorted)

end
##########inserting nodes and leaves in the tree###########
def build_tree([h | []]) do
  h
end
def build_tree([first,second | restofsorted]) do
  tree = insert_leaf(first,second)
  newListSorted = insertRight(tree,restofsorted)
  build_tree(newListSorted)
end

def insertRight({freq,left,right}= l,[{f,_,_} = h | t]) do
  cond do
    freq < f -> [l, h | t]
    true -> [h | insertRight(l,t)]
  end
end
def insertRight({freq,left,right}= l,[{_,f} = h | t]) do
  cond do
    freq < f -> [l, h | t]
    true -> [h | insertRight(l,t)]
  end
end
def insertRight({freq,left,right} = l, []) do
  [l]
end
def insert_leaf({char1, freq1},{char2,freq2})do
  cond do
    freq1 < freq2 -> {freq1 + freq2,{char1, freq1},{char2,freq2}}
    true -> {freq1 + freq2,{char2, freq2},{char1,freq1}}
  end
end
def insert_leaf({freq1,_,_} = l1,{freq2,_,_} = l2) do
  cond do
    freq1 < freq2 -> {freq1 + freq2, l1,l2}
    true -> {freq1 + freq2,l2,l1}
  end
end
def insert_leaf({char,freq},{freq2,left,right}=l) do
  cond do
    freq < freq2 -> {freq + freq2, {char,freq},l}
    true -> {freq + freq2,l,{char,freq}}
  end
end
def insert_leaf({freq2,left,right}=l,{char,freq}) do
  cond do
    freq < freq2 -> {freq + freq2, {char,freq},l}
    true -> {freq + freq2,l,{char,freq}}
  end
end

def freq(sample) do
freq(sample, [])
end
def freq([], freq) do
freq
end
def freq([char | rest], freq) do
freq(rest, charcounter(char,freq))
end
###### charcounter##########
def charcounter(char, []) do
  [{char, 1}]
end
def charcounter(char,[{char, x} | freq]) do
  [{char, x + 1} | freq]
end
def charcounter(char, [ a | freq]) do
  [a | charcounter(char,freq)]
end

######insertionsort###########
def insertf([{char,freq}], []) do [{char,freq}] end
def insertf([{char1,freq1}],[{char,freq} | rest]) do
cond do
  freq < freq1 -> [{char,freq} | insertf([{char1,freq1}],rest)]
  true -> [{char1,freq1} , {char,freq} | rest]
end
end

def isort(l) do
isort(l,[])
end
def isort([], sorted) do
sorted
end
def isort([h1 | t1], []) do
  isort(t1,[h1])
end
def isort([h1 | t1], sorted) do
#insert(h1,sorted)
isort(t1,insertf([h1],sorted))
end






def encode_table(tree) do

end
def decode_table(tree) do
  # To implement...
end
def encode(text, table) do
# To implement...
end
def decode(seq, tree) do
# To implement...
end

end
