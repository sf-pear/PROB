#!/usr/bin/env bash

echo running training of prob-detr, fathomnet dataset

set -x

EXP_DIR=exps/FATHOMNET
PY_ARGS=${@:1}
WANDB_NAME=fathomnet

# train task 1
python -u main_open_world.py \
    --output_dir "${EXP_DIR}/t1" --dataset fathomnet --PREV_INTRODUCED_CLS 0 --CUR_INTRODUCED_CLS 10\
    --train_set 'task1_train' --test_set 'all_test' --epochs 41\
    --model_type 'prob' --obj_loss_coef 8e-4 --obj_temp 1.3\
    --wandb_name "${WANDB_NAME}_t1" --exemplar_replay_selection --exemplar_replay_max_length 850\
    --exemplar_replay_dir ${WANDB_NAME} --exemplar_replay_cur_file "t1_ft.txt"\
    ${PY_ARGS}
    
# train task 2
PY_ARGS=${@:1}
python -u main_open_world.py \
    --output_dir "${EXP_DIR}/t2" --dataset fathomnet --PREV_INTRODUCED_CLS 10 --CUR_INTRODUCED_CLS 2\
    --train_set 'task2_train' --test_set 'all_test' --epochs 51\
    --model_type 'prob' --obj_loss_coef 8e-4 --obj_temp 1.3 --freeze_prob_model\
    --wandb_name "${WANDB_NAME}_t2"\
    --exemplar_replay_selection --exemplar_replay_max_length 1743 --exemplar_replay_dir ${WANDB_NAME}\
    --exemplar_replay_prev_file "t1_ft.txt" --exemplar_replay_cur_file "t2_ft.txt"\
    --pretrain "${EXP_DIR}/t1/checkpoint0040.pth" --lr 2e-5\
    ${PY_ARGS}
    
# fine tune task 2
PY_ARGS=${@:1}
python -u main_open_world.py \
    --output_dir "${EXP_DIR}/t2_ft" --dataset fathomnet --PREV_INTRODUCED_CLS 10 --CUR_INTRODUCED_CLS 2 \
    --train_set "${WANDB_NAME}/t2_ft" --test_set 'all_test' --epochs 111 --lr_drop 40\
    --model_type 'prob' --obj_loss_coef 8e-4 --obj_temp 1.3\
    --wandb_name "${WANDB_NAME}_t2_ft"\
    --pretrain "${EXP_DIR}/t2/checkpoint0050.pth"\
    ${PY_ARGS}
    

# train task 3
PY_ARGS=${@:1}
python -u main_open_world.py \
    --output_dir "${EXP_DIR}/t3" --dataset fathomnet --PREV_INTRODUCED_CLS 12 --CUR_INTRODUCED_CLS 2\
    --train_set 'task3_train' --test_set 'all_test' --epochs 121\
    --model_type 'prob' --obj_loss_coef 8e-4 --freeze_prob_model --obj_temp 1.3\
    --wandb_name "${WANDB_NAME}_t3"\
    --exemplar_replay_selection --exemplar_replay_max_length 2361 --exemplar_replay_dir ${WANDB_NAME}\
    --exemplar_replay_prev_file "t2_ft.txt" --exemplar_replay_cur_file "t3_ft.txt"\
    --pretrain "${EXP_DIR}/t2_ft/checkpoint0110.pth" --lr 2e-5 \
    ${PY_ARGS}
    
# fine tune task 3
PY_ARGS=${@:1}
python -u main_open_world.py \
    --output_dir "${EXP_DIR}/t3_ft" --dataset fathomnet --PREV_INTRODUCED_CLS 12 --CUR_INTRODUCED_CLS 2 \
    --train_set "${WANDB_NAME}/t3_ft" --test_set 'all_test' --epochs 181 --lr_drop 35\
    --model_type 'prob' --obj_loss_coef 8e-4 --obj_temp 1.3\
    --wandb_name "${WANDB_NAME}_t3_ft"\
    --pretrain "${EXP_DIR}/t3/checkpoint0120.pth"\
    ${PY_ARGS}


# # can't train task 4 - see issue #37 in PROB repo: https://github.com/orrzohar/PROB/issues/37
# # train task 4
# PY_ARGS=${@:1}
# python -u main_open_world.py \
#     --output_dir "${EXP_DIR}/t4" --dataset fathomnet --PREV_INTRODUCED_CLS 14 --CUR_INTRODUCED_CLS 6\
#     --train_set 'task4_train' --test_set 'all_test' --epochs 191 \
#     --model_type 'prob' --obj_loss_coef 8e-4 --freeze_prob_model --obj_temp 1.3\
#     --wandb_name "${WANDB_NAME}_t4"\
#     --exemplar_replay_selection --exemplar_replay_max_length 2749 --exemplar_replay_dir ${WANDB_NAME}\
#     --exemplar_replay_prev_file "t3_ft.txt" --exemplar_replay_cur_file "t4_ft.txt"\
#     --num_inst_per_class 40\
#     --pretrain "${EXP_DIR}/t3_ft/checkpoint0180.pth" --lr 2e-5\
#     ${PY_ARGS}
    
# # fine tune task 4    
# PY_ARGS=${@:1}
# python -u main_open_world.py \
#     --output_dir "${EXP_DIR}/t4_ft" --dataset fathomnet --PREV_INTRODUCED_CLS 14 --CUR_INTRODUCED_CLS 6\
#     --train_set "${WANDB_NAME}/t4_ft" --test_set 'all_test' --epochs 261 --lr_drop 50\
#     --model_type 'prob' --obj_loss_coef 8e-4 --obj_temp 1.3\
#     --wandb_name "${WANDB_NAME}_t4_ft"\
#     --pretrain "${EXP_DIR}/t4/checkpoint0190.pth" \
#     ${PY_ARGS}
