using Distributed

workervec = [("ubuntu@18.221.214.62:22", 2)]
addprocs(workervec; sshflags=`-i ./JuliaServer.pem`, tunnel=true, exename=`/home/ubuntu/julia-1.2.0/bin/julia`)
@everywhere using Distributed
#@everywhere import Pkg
#@everywhere Pkg.instantiate()
#@everywhere Pkg.add("PyCall")
@everywhere using PyCall
@everywhere @pyimport socket
println(workers())

@everywhere function printhello(data)
	println("hi from node ", myid())
	println("my hostname is ", socket.gethostname())
	println(" and the data is ", data)
end

x = [@spawnat i printhello(i*10) for i in workers()]