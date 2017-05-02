var evaluate = function (formData) {
    var data = JSON.parse(formData);
    var evaluatorModel = [];
    console.log(data.data);
    for (var i = 0; i < data.data.length; i++) {
        var section = data.data[i];
        console.log(section);
        var fieldGroup = section.fieldGroup;
        console.log(fieldGroup);
        for (var field in fieldGroup) {
            var fieldKey = field.key;
            var props = field.properties;
            var singleEvaluatorModel = [];
            for (var propKey in props) {
                if (propKey !== 'label' && propKey !== 'placeholder') {
                    singleEvaluatorModel[propKey] = field.propKey;
                }
            }
            evaluatorModel[fieldKey] = singleEvaluatorModel;
        }
    }
    console.log(evaluatorModel);
    return evaluatorModel;
};