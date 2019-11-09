using Distributed

workervec = [("ubuntu@18.221.214.62", 1)]
addprocs(workervec; sshflags=`-i /home/moxnox/tdl-2c2019/JuliaServer.pem`, tunnel=true, exename=`/usr/local/bin/julia`)

@everywhere using Distributed
@everywhere using PyCall
@everywhere @pyimport socket
println(workers())

@everywhere function printhello(data)
	println("hi from node ", myid())
	println("my hostname is ", socket.gethostname())
	println(" ann the data is ", data)
end

x = [@spawnat i printhello(i*10) for i in workers()]