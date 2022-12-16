### Code from MS TechCommunity https://techcommunity.microsoft.com/t5/azure-compute-blog/automate-beeond-filesystem-on-azure-cyclecloud-slurm-cluster/ba-p/3625544

# Download Prolog/Epilog scripts to /sched
sudo wget -O /sched/slurm_prolog.sh https://raw.githubusercontent.com/wolfgang-desalvador/cyclecloud-slurm-beeond/main/specs/scheduler/cluster-init/files/slurm-prolog-beeond.sh
sudo wget -O /sched/slurm_epilog.sh https://raw.githubusercontent.com/wolfgang-desalvador/cyclecloud-slurm-beeond/main/specs/scheduler/cluster-init/files/slurm-epilog-beeond.sh

# Make the scripts executable
sudo chmod +x /sched/slurm_*.sh

# Add the logs directory if it doesn't exist
[ -d /sched/log ] || sudo mkdir /sched/log

# add Prolog/Epilog configs to slurm.conf
sudo cat <<EOF >>/sched/slurm.conf
Prolog=/sched/slurm_prolog.sh
Epilog=/sched/slurm_epilog.sh
EOF

# force cluster nodes to re-read the slurm.conf
sudo scontrol reconfig