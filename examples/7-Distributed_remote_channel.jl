using Distributed

workervec = [("ubuntu@18.221.214.62:22", 2)]
addprocs(workervec; sshflags=`-i ./JuliaServer.pem`, tunnel=true, exename=`/home/ubuntu/julia-1.2.0/bin/julia`, dir="/home/ubuntu/tdl-2c2019")
addprocs(2)
@everywhere using Distributed
@everywhere using PyCall
@everywhere foo = pyimport("socket")
println(workers())

@everywhere function listenChannel(channel)
	println("Listen Started")
	id = 1
	while(id != -1)
		id = take!(channel)
		message = string("I'm process: ", string(myid()), " and i read element: ", id, " from the channel")
		println(message)
	end
	println(string("i'm process: ", string(myid()), " and i'm finished listening"))
end

#Crea un canal remoto, para el pid 1(el main process) que alojara un canal vacio de 1000 Strings
channel = RemoteChannel(() -> Channel{String}(1000), 1)
x = [@spawnat i listenChannel(channel) for i in workers()]

#pero ahora populo el canal para que los procesos extraigan del canal
function fillChannel(channel, size)
	for i=1:size
		put!(channel, string("Elemento: ", i))
	end

	for i=1:length(workers())
		put!(channel, string(-1))
	end
end

sleep(10)
println("filling the channel")
fillChannel(channel, 4)
#detener los procesos
interrupt(workers())