using Distributed

workervec = [("ubuntu@18.221.214.62:22", 2)]
addprocs(workervec; sshflags=`-i ./JuliaServer.pem`, tunnel=true, exename=`/home/ubuntu/julia-1.2.0/bin/julia`, dir="/home/ubuntu/tdl-2c2019")
addprocs(2)
@everywhere using Distributed
println("Qty workers: ", workers())

@everywhere function fibonacci(n)
	if(n < 2)
		return n
	else
		return fibonacci(n-1) + fibonacci(n-2)
	end
end

@everywhere function parallel_fibonacci(n)
	if(n < 10)
		return fibonacci(n)
	else
		x::Int = @spawn parallel_fibonacci(n-1)
		y::Int = parallel_fibonacci(n-2)
		return fetch(x) + y
	end
end

println(@time [@spawn fibonacci(i) for i=1:40])
println(@time [@spawn parallel_fibonacci(i) for i=1:40])
