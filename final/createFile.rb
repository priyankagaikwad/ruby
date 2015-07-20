require 'json'
require 'fileutils'
#require 'pathname'


def declareInHeaderFile(data,header_file)
  header_file.puts "\n"
  for x in data.keys
    case data[x]
      when String
        header_file.puts "\tvoid set" +x+ "(string " + x + ");"
        header_file.puts "\tstring get" + x + "();"
      when Fixnum
        header_file.puts "\tvoid set" +x+ "(int " + x + ");"
        header_file.puts "\tint get" + x + "();"
      when TrueClass
        header_file.puts "\tvoid set" +x+ "(bool " + x + ");"
        header_file.puts "\tbool get" + x + "();"
      when Array
        header_file.puts "\tvoid set"+ x +"( ArraList "+x+");"
        header_file.puts "\tArrayList <"+x+"> get"+ x +"();"                
      when Hash
        header_file.puts ("\tvoid set"+x + "(" + x + "obj);")
        header_file.puts "\t"+x +" get"+x+"();"        
    end    
  end
end  

def addIncludeFile(x,include_file)
  
  include_file.puts "#include \"" + x + ".h\""
   
end

def writeHeaderFile(data,header_file,cpp_file,folder_name,include_file)
  header_file.puts "public:"
  for x in data.keys
    case data[x]
      when String
        header_file.puts "\tstring " + x + ";"
        cpp_file.puts("\nvoid set"+ x +"( string "+x+")\n{\n\t//set" + x +";\n}")
        cpp_file.puts("\nstring get"+ x +"() {   return " + x +";\t}")
      when Fixnum
        header_file.puts "\tint " + x + ";"
        cpp_file.puts("\nvoid set"+ x +"( int "+x+" )\n{\n\t//set" + x +";\n}")
        cpp_file.puts("\nint get"+ x +"() {   return " + x +";\t}")
      when TrueClass
        header_file.puts "\tbool " + x + ";"
        cpp_file.puts("\nvoid set"+ x +"( bool "+x+")\n{\n\t//set" + x +";\n}")
        cpp_file.puts("\nbool get"+ x +"() {   return " + x +";\t}")
      when Array        
        header_file.puts  "\tArrayList <"+ x +"> "+ x +"list ;"
       
        cpp_file.puts("\nvoid set"+ x +"( ArraList "+x+")\n{\n\t//set" + x +";\n}")
        cpp_file.puts("\nArrayList <"+ x +"> get"+ x +"() {   return " + x +";\t}")

        addIncludeFile(x,include_file)
               
        array_data = Hash[x, data[x]] 
        createFile(array_data,folder_name,include_file)
      when Hash
        header_file.puts ("\t"+x + " " + x + "obj;")
        cpp_file.puts("\nvoid set"+ x +"("+x+" "+ x +"obj)\n{\n\t//set" + x +";\n}")
        cpp_file.puts("\n"+ x +" get"+ x +"() {   return " + x +";\t}")
        
        addIncludeFile(x,include_file)
        array_data = Hash[x, data[x]] 
        createFile(array_data,folder_name,include_file)
    end    
  end
end  

def createFileWithBasicStructure(x,header_file,cpp_file)
      header_file.puts "#include <iostream>"
      header_file.puts "#include <include.h>"
      header_file.puts "class " + x
      header_file.puts "{"

      cpp_file.puts "#include <iostream>"
      cpp_file.puts "#include \"" + x + ".h\""
      cpp_file.puts "using namespace std;\n"

      cpp_file.puts "\n"+ x +"::" + x +"()"
      cpp_file.puts "{" 
      cpp_file.puts "//constructor"
      cpp_file.puts "}"
end

def closeFile(file)
  file.puts "}"
  file.close
end

def createFile(file_data,folder_name,include_file)
  for x in file_data.keys
      header_file = File.new(folder_name+"/" + x+".h","w+")
      cpp_file = File.new(folder_name+"/" + x +".cpp","w+")
    if file_data[x].class == Hash    
      createFileWithBasicStructure(x,header_file,cpp_file)
      inner_hash = file_data[x]
      writeHeaderFile(inner_hash,header_file,cpp_file,folder_name,include_file)
      declareInHeaderFile(inner_hash,header_file)      
      closeFile(header_file)
      cpp_file.close

    elsif file_data[x].class == Array
      createFileWithBasicStructure(x,header_file,cpp_file)      
      inner_array = file_data[x]      
      writeHeaderFile(inner_array[0],header_file,cpp_file,folder_name,include_file)
      declareInHeaderFile(inner_array[0],header_file)      
      closeFile(header_file)
      cpp_file.close
      
    elsif file_data[x].class == String || file_data[x].class == Fixnum || file_data[x].class == TrueClass
      class_data = Hash["dummy", file_data] 
      createFile(class_data,folder_name,include_file) 

    end
  end
end

def parseJsonFile(file_name,folder_path)
  file = File.read(file_name)
  file_data = JSON.parse(file)
  puts file_data.keys[0]
  folder_name = folder_path + "/output" + file_data.keys[0]
  FileUtils::mkdir_p folder_name
  if !file_data.empty?
    include_file = File.new(folder_name+"/include.h","w+")  
  else
    puts "empty"
  end  
end

def traverseDirectory(folder_path)
  Dir.foreach(folder_path) do |x|
    path = File.join(folder_path, x)
    if x == "." or x == ".."
      next
    elsif File.directory?(path)      
      traverseDirectory(path)
    else
      if x.include? ".json"
        file_name = folder_path +"/" +x
        parseJsonFile(file_name,folder_path)
      end
      
    end
  end
end

traverseDirectory ('/home/synerzip/RUBY/final')
