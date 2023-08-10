#!/usr/bin/env bash

echo running eval prob-detr, fathomnet all_eval dataset

set -x

EXP_DIR=exps/FATHOMNET
PY_ARGS=${@:1}
    
PY_ARGS=${@:1}
python -u main_open_world.py \
    --output_dir "${EXP_DIR}/eval" --dataset fathomnet --PREV_INTRODUCED_CLS 0 --CUR_INTRODUCED_CLS 10 \
    --train_set "task1_train" --test_set 'all_eval' --epochs 191 --lr_drop 35\
    --model_type 'prob' --obj_loss_coef 8e-4 --obj_temp 1.3\
    --pretrain "${EXP_DIR}/t1/checkpoint0040.pth" --eval --wandb_project ""\
    ${PY_ARGS}
    
    
PY_ARGS=${@:1}
python -u main_open_world.py \
    --output_dir "${EXP_DIR}/eval" --dataset fathomnet --PREV_INTRODUCED_CLS 10 --CUR_INTRODUCED_CLS 2 \
    --train_set "task1_train" --test_set 'all_eval' --epochs 191 --lr_drop 35\
    --model_type 'prob' --obj_loss_coef 8e-4 --obj_temp 1.3\
    --pretrain "${EXP_DIR}/t2_ft/checkpoint0110.pth" --eval --wandb_project ""\
    ${PY_ARGS}
    
    
PY_ARGS=${@:1}
python -u main_open_world.py \
    --output_dir "${EXP_DIR}/eval" --dataset fathomnet --PREV_INTRODUCED_CLS 12 --CUR_INTRODUCED_CLS 2 \
    --train_set "task1_train" --test_set 'all_eval' --epochs 191 --lr_drop 35\
    --model_type 'prob' --obj_loss_coef 8e-4 --obj_temp 1.3\
    --pretrain "${EXP_DIR}/t3_ft/checkpoint0180.pth" --eval --wandb_project ""\
    ${PY_ARGS}
    
    
# PY_ARGS=${@:1}
# python -u main_open_world.py \
#     --output_dir "${EXP_DIR}/eval" --dataset fathomnet --PREV_INTRODUCED_CLS 14 --CUR_INTRODUCED_CLS 6 \
#     --train_set "task1_train" --test_set 'all_eval' --epochs 191 --lr_drop 35\
#     --model_type 'prob' --obj_loss_coef 8e-4 --obj_temp 1.3\
#     --pretrain "${EXP_DIR}/t4.pth" --eval --wandb_project ""\
#     ${PY_ARGS}
    
    