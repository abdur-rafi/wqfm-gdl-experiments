generate_est_one_cond_path="gt-estimation-scripts/generate_est_one_cond.sh"

root=$1
save_to=$2

if [ -z "$root" ]; then
  echo "Usage: $0 <model_condition_folder_path>"
  exit 1
fi

if [ ! -d "$root" ]; then
  echo "The specified folder does not exist: $root"
  exit 1
fi

if [ -z "$save_to" ]; then
  echo "Usage: $0 <model_condition_folder_path> <save_to>"
  exit 1
fi
if [ ! -d "$save_to" ]; then
  echo "The specified save directory does not exist."
  exit 1
fi


  # "sim200_dup0_ILS25"
  # "sim200_dup0_ILS50"

# model_conditions=(
#   "sim200_dup1_ILS25"
#   "sim200_dup3_ILS25"
# )
  # "sim500_dup0_ILS25"
  # "sim500_dup0_ILS50"

model_conditions=(
    # sim200_dup0_ILS70
    # sim500_dup0_ILS70
    # sim500_dup1_loss0.1
    # sim500_dup3_ILS25
    # sim500_dup3_loss0.1
    # sim500_dup3_loss1
    sim500_dup1_loss1
    # new_S25   
)


# for model_cond in $(ls $root); do
for model_cond in "${model_conditions[@]}"; do

    # check if $model_cond is a directory
        if [ -d $root/$model_cond ]; then
            echo $model_cond
            mkdir -p $save_to/$model_cond
            bash "$generate_est_one_cond_path" "$root/$model_cond" "$save_to/$model_cond"
            # break
        fi

    done