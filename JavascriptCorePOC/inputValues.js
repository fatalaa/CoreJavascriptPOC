var model = {
    baseValue: 'ASSAD',
    section1: {
        baseValue: {
            value: 'BLAALB'
        }
    },
    section2: {
        dynamicDisabled: {
            disabled: "${model.baseValue === \"y\"};"
        },
        dynamicReadonly: {
            readonly: "${model.section1.baseValue === \"x\"};"
        },
        sub: {
            sub: {
                dynamicHidden: {
                    hide: "${model.baseValue === \"z\"};"
                }
            }
        }
    }
};
