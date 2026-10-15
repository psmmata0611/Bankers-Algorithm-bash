#!/bin/bash

# Number of processes and resources
read -p  "Enter number of processes: " n 
read -p "Enter number of resources: " m


# Initialize arrays for resources
available=()   #available resources 
max=()         # Maximum demand of each process
alloc=()       # Allocated resources to processes
need=()        # Needed resources for processes

#1-D array indicatinig the number of available resources
echo "Enter available resources: "
for((i = 0; i < m; i++)); do
        read -p " Resource $((i + 1)):" available[$i]
done


#2-D array that defines the maximun demand of each process in a system
echo "Enter Maximum demand for each process:"
for((i = 0; i < n; i++)); do
	echo "For process P$i"
	for((j = 0; j < m; j++)); do
		read -p "Resource $j: " value
		max[$((i * m + j))]=$value
	done 
done

#2-D array that defines the number of resources of each  currently allocated to each process
echo "Enter currently alloccated resources:"
for((i = 0; i < n; i++)); do
	echo "For process P$i"
        for((j = 0; j < m; j++)); do
                read -p "Resources $j: " value
		max_val=${max[$((i * m + j))]}
		while [ "$value" -gt "$max_val" ]; do
			echo "Allocation cannot be more than the maximum demand ($max_val)."
			read -p "Resources $j: " value
		done
		alloc[$((i * m + j))]=$value
        done    
done

#2-D array that indicates the remaining resource need to each process
for((i = 0; i < n; i++)); do
        for((j =0; j < m; j++)); do
		need[$((i * m + j))]=$((max[$((i * m + j))] - alloc[$((i * m + j))]))
	done

done

#Algotithm for finding out whether or not the system is in a safe state
SafetyCheck()
{
    work=("${available[@]}")  # Work array = available resources
   
	    finish=()  
    # Initialize finish array 
    for ((i = 0; i < n; i++)); do
        finish[$i]=0
    done

    safe=()  # Store the safe sequence
    track=0  # Track finished processes

    while [ $track -lt $n ]; do
        found=0
        for ((i = 0; i < n; i++)); do
	         if [ "${finish[$i]}" -eq 0 ]; then	
# Check if its need can be met with work(available) resources
                execute=true
                for ((j = 0; j < m; j++)); do
			if [ "${need[$((i * m + j))]}" -gt "${work[$j]}" ]; then 	  
   			 execute=false
                        break
                    fi
                done

 # If process can be executed
                if [ "$execute" == true ]; then
                    for ((j = 0; j < m; j++)); do
			    work[$j]=$((work[$j] + alloc[$((i * m + j))]))
                    done

                    finish[$i]=1  # Mark process  as finished
                    safe+=("P$i")  # Add process to safe sequence
                    ((track++))  # Increment the finished process
                    found=1
                    break
                fi
	fi 
        done

        # If no process was found deadlock occurs
        if [ $found -eq 0 ]; then
            echo "System is in an UNSAFE state (possible deadlock)."
            return 1
       	fi
    done

#print safe sequence
echo "System is in a SAFE STATE."
echo "Safe sequence: ${safe[@]}"
return  0
}

# Function to print tables  
tables() {
echo "$1"     
local -n matrix=$2

for ((i = 0; i < n; i++)); do  

printf "P%d: " "$i"
for ((j = 0; j < m; j++)); do  
printf "%d " "${matrix[$((i * m + j))]}"  

	done  

	echo  
done 
}  

# Print Maximum, Allocation, and Need tables  
tables "Maximum Resources:" max
tables "Allocation:" alloc
tables "Need:" need



#function to request adding a new process and verify the safety of the system with added process
NewResources(){
echo -e "Do you want to request for more process? [Y/N]"
read res

while [[ "$res" == "Y" || "$res" == "y" ]]; do
       req_p=$n	
	echo "Adding a new process P$req_p"
        for ((j = 0; j < m; j++)); do
                read -p "Maximun demand for resources $j: " value
		max[$((req_p * m + j))]=$value
		alloc[$((req_p * m + j))]=0
		need[$((req_p * m + j))]=$value
	done 

	echo "Checking System safety for new process"
	((n++))
	if SafetyCheck; then	
	echo " New process P$req_p added."
	tables "Updated Maximum Resources:" max
	tables "Updated Allocation:" alloc
	tables "Updated Need" need
else 
	((n--))
	echo " Request denied: adding P$req_p would make the system unsafe."
	
	fi

	echo -e "Do you want to request for more process? [Y/N]:"
       read res
done    
echo " No new process added.Exiting program."
	}

#run safety check
SafetyCheck || exit 1  
NewResources



