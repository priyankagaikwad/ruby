require 'json'
require 'fileutils'


def declareGetSetMethods(data,file)
# puts data.keys
for x in data
    case x[1]
    when String
       file.puts("void set"+ x[0] +"( string "+ x[0] +");")       
       file.puts("string get"+ x[0] +"();")       
       # puts(x)
    when Array
       # puts(x)
       file.puts "//for "+ x[0] + " array" + ";"

       #createNewClass(x[0])
       
    when Fixnum
       # puts(x)
       file.puts("void set"+ x[0] +"( int "+ x[0] +");")
       file.puts("int get"+ x[0] +"();")
    
    when Hash
    	file.puts("//do "+x[0] + " hashObj ;")
    	# hash_data = Hash[*x.flatten]
    	# puts hash_data
    	# createHeaderFile(hash_data)
    else
       #file.puts "}"
       puts x[0]
    end
end

end


def createMemberVariableForArray(data,file)
for x in data
    case x[1]
    when String
       file.puts "string " + x[0] + ";"       
    when Array
       file.puts x[0] + " obj[5]" + ";"
       array_data = x
       puts "array_data"
       puts array_data
       createHeaderFileIfArray(array_data)
    when Fixnum
       file.puts "int " + x[0] + ";"
    when Hash
      file.puts(x[0] + " hashObj ;")
      hash_data = Hash[*x.flatten]
      createHeaderFile(hash_data)
    when TrueClass
      file.puts "bool " + x[0] + ";" 
      
    # else
    #   puts "else start"
    #    puts x
    #    createMemberVariable(x,file)
    #    puts x[0]
    #    puts "else"
    end
end

end

def createMemberVariable(data,file)
puts "In createMemberVariable"
#puts data
for x in data.keys
   puts "X:"
   puts data[x]  
   if data[x].class == Hash then
     data1 = data[x]
     # puts "header file "
     # puts x
  
    for inner_hash in data1
      puts "innerHash"
      #puts inner_hash
      case inner_hash[1]
      when String
        puts "string"
        file.puts "string " + inner_hash[0] + ";"
      when Fixnum
        puts "Fixnum"
        file.puts "int " + inner_hash[0] + ";"
      when Array
        puts "array"
        file.puts inner_hash[0] + " obj[5]" + ";"
        array_data = inner_hash
        createHeaderFileIfArray(array_data)
      when Hash
        puts "Hash"
        file.puts(inner_hash[0] + " hashObj ;")
        hash_data = Hash[*inner_hash.flatten]
      
        createHeaderFile(hash_data)
      when TrueClass
        file.puts "bool " + x[0] + ";"               
      end
    end
  
 elsif data[x].class == Array then
  puts "elseif array"
  puts data
  for inner_hash in data
      puts "innerArray"
      puts inner_hash
      case inner_hash[1]
      when String
        puts "string"
        file.puts "string " + inner_hash[0] + ";"
      when Fixnum
        puts "Fixnum"
        file.puts "int " + inner_hash[0] + ";"
      when Array
        puts "array"
        file.puts inner_hash[0] + " obj[5]" + ";"
        array_data = inner_hash
        createHeaderFileIfArray(array_data)

      when Hash
        puts "Hash"
        file.puts(inner_hash[0] + " hashObj ;")
        hash_data = Hash[*inner_hash.flatten]
        createHeaderFile(hash_data)
      when TrueClass
        file.puts "bool " + x[0] + ";"               
      end
    end
 end
     
end

end

def createHeaderFileIfArray(array_data)

puts "array_data"
#puts array_data
	header_file = File.new("output/" + array_data[0]+".h","w+")
 header_file.puts "#include <iostream>"
 header_file.puts "class " + array_data[0]
 header_file.puts "{" 

 data = array_data[1]
 puts("createHeaderFileIfArray data")
# puts array_data
 data1 = data.first
 # puts()
 # puts data1
 createMemberVariableForArray(data1,header_file)
 
 declareGetSetMethods(data1,header_file)
 header_file.puts "}"
 header_file.close 

end

def createHeaderFile(file_data)
 puts "header file "
 header_file = File.new("output/" + file_data.keys[0]+".h","w+")
 header_file.puts "#include <iostream>"
 header_file.puts "class " + file_data.keys[0]
 header_file.puts "{" 
 
 createMemberVariable(file_data,header_file)
 header_file.puts()
 #declareGetSetMethods(file_data,header_file)
 header_file.puts "}"
 header_file.close 
end

def createCppFile(file_data)
	cpp_file = File.new("output/" +file_data.keys[0]+".cpp","w+")
 cpp_file.puts "#include \"" +file_data.keys[0] +".h\""
#constructor
 cpp_file.puts file_data.keys[0] +"::" + file_data.keys[0] +"()"
 cpp_file.puts "{" 
 cpp_file.puts "//constructor"
 cpp_file.puts "}"
#setter and getter 
 cpp_file.close
end


file = File.read('data3.json')
file_data = JSON.parse(file)
FileUtils::mkdir_p 'output'
puts file_data[0]

createHeaderFile(file_data)
createCppFile(file_data)
