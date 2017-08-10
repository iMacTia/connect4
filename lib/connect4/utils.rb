def current_folder
  File.expand_path(File.dirname(__FILE__))
end

def join_path(path)
  File.join(current_folder, path)
end

def player_klass(sym)
  Kernel.const_get("Players::#{sym}")
end