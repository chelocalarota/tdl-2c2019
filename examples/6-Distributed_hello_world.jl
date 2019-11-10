using Distributed
#@everywhere import Pkg
#@everywhere Pkg.instantiate()
#@everywhere Pkg.add("PyCall")

workervec = [("ubuntu@18.221.214.62:22", 2)]
addprocs(workervec; sshflags=`-i /home/moxnox/tdl-2c2019/JuliaServer.pem`, tunnel=true, exename=`/home/ubuntu/julia-1.2.0/bin/julia`, dir="/home/ubuntu/tdl-2c2019")
addprocs(2)
@everywhere using Distributed
@everywhere using PyCall
@everywhere socket = pyimport("socket")
println("Qty workers: ", workers())

@everywhere function printhello(data)
	println("hi from node ", myid())
	println("my hostname is ", socket.gethostname())
	println(" and the data is ", data)
end

@sync [@spawnat i printhello(i*10) for i in workers()]
