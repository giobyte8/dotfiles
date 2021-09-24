#!/bin/bash

function woai-logs {
    FN_RES_CREATE="int16-webhook-outbound-ad-ReservationCreateFunctio-18FO3D730QCR3"
    FN_RES_MODIFY="int16-webhook-outbound-ad-ReservationModifyFunctio-7HH3J491PM1V"
    FN_GROUP_CREATE="int16-webhook-outbound-adapter-GroupCreateFunction-1BXB4TRF351AS"
    FN_GROUP_MODIFY="int16-webhook-outbound-adapter-GroupModifyFunction-4S88BPE1UDX5"
    FN_GROUP_CANCEL="int16-webhook-outbound-adapter-GroupCancelFunction-141PWUZMS7Z9P"
    FN_INV_BATCH="int16-webhook-outbound-adap-InventoryBatchFunction-ICN96K7E93ZV"

    TARGET_FN=$1

    case $TARGET_FN in
        "reservationCreate") TARGET_FN=$FN_RES_CREATE;;
        "reservationModify") TARGET_FN=$FN_RES_MODIFY;;
        "groupCreate") TARGET_FN=$FN_GROUP_CREATE;;
        "groupModify") TARGET_FN=$FN_GROUP_MODIFY;;
        "groupCancel") TARGET_FN=$FN_GROUP_CANCEL;;
        "inventoryBatch") TARGET_FN=$FN_INV_BATCH;;
        *)
            echo "ERROR: Invalid function name"
            return
    esac

    sam logs -n ${TARGET_FN} --profile skydev "${@:2}"
}

function woai-vencert-logs {
    FN_RES_CREATE="woai-int16-atf-tmp-ReservationCreateFunction-1ODBQHZB7YVZW"
    FN_RES_MODIFY="woai-int16-atf-tmp-ReservationModifyFunction-1RU0X4KW7QJNY"
    FN_GROUP_CREATE="woai-int16-atf-tmp-GroupCreateFunction-BN363VOW2SZM"
    FN_GROUP_MODIFY="woai-int16-atf-tmp-GroupModifyFunction-GKA1YITX9XLC"
    FN_GROUP_CANCEL="woai-int16-atf-tmp-GroupCancelFunction-1BYEZ8KW7S0MS"
    FN_INV_BATCH="woai-int16-atf-tmp-InventoryBatchFunction-1Q3P63HZPHGU2"

    TARGET_FN=$1

    case $TARGET_FN in
        "reservationCreate") TARGET_FN=$FN_RES_CREATE;;
        "reservationModify") TARGET_FN=$FN_RES_MODIFY;;
        "groupCreate") TARGET_FN=$FN_GROUP_CREATE;;
        "groupModify") TARGET_FN=$FN_GROUP_MODIFY;;
        "groupCancel") TARGET_FN=$FN_GROUP_CANCEL;;
        "inventoryBatch") TARGET_FN=$FN_INV_BATCH;;
        *)
            echo "ERROR: Invalid function name"
            return
    esac

    sam logs -n ${TARGET_FN} --profile skyvencert "${@:2}"
}


