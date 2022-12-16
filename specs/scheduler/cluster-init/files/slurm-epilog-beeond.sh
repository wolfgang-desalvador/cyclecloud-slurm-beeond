#!/bin/bash
### Code derived from MS TechCommunity https://techcommunity.microsoft.com/t5/azure-compute-blog/automate-beeond-filesystem-on-azure-cyclecloud-slurm-cluster/ba-p/3625544

set -x

if [ "$(sudo /opt/cycle/jetpack/bin/jetpack config slurm.hpc)" == "True" ]; then
  nodefile=/shared/home/$SLURM_JOB_USER/nodefile-$SLURM_JOB_ID
  if [ -e $nodefile ] ; then

    logdir="/sched/log"
    logfile=$logdir/slurm_epilog.log

    # Workaround Beeond stop umount issue
    ! mount | grep beeond || sudo umount -l /mnt/beeond

    echo "$(date).... Stopping beeond"
    while read host; do
      if [ "${host}" == "$(hostname)" ]; then
        sudo -u $SLURM_JOB_USER beeond stop -n $nodefile -L -d -P -c
      fi
      break
    done < $nodefile

    # Workaround Beeond stop umount issue
    ! mount | grep beeond || sudo umount -l /mnt/beeond

    #rm $nodefile
  fi
fi