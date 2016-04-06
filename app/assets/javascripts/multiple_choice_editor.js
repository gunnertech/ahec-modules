// Probably the ugliest code I have ever written, but no need to add Backbone
// for 1 small part of the entire app, and I don't want each button press to 
// refrsh the page...

// TODO:  
// - Validation
// - Commentify
// - Select radio of correct answer in deserialization

function getYoutubeIdFromUrl(url){
  var regExp = /^.*((youtu.be\/)|(v\/)|(\/u\/\w\/)|(embed\/)|(watch\?))\??v?=?([^#\&\?]*).*/;
  var match = url.match(regExp);
  return (match&&match[7].length==11)? match[7] : url;
}

var questionRollover = 0;
function addQuestion() {
  questionRollover += 1;

  var newQuestion = "<fieldset id=\"question-new-" + questionRollover + "\">";
  newQuestion += "<input type=\"text\"/>";
  newQuestion += "<input class=\"btn pull-right btn-danger\" type=\"button\" value=\"Delete Question\" " +
    "onclick=\"deleteQuestion(" + questionRollover + ", true);\"/>";
  newQuestion += "<input class=\"btn btn-primary\" id=\"question-new-" + questionRollover + "-add-choice-button\" type=\"button\" value=\"Add Choice\" " +
        "onclick=\"addChoice(" + questionRollover + ", true);\"/>";
  newQuestion += "</fieldset>";

  $("#course-question-editor").append(newQuestion);
}

var choiceRollover = 0;
function addChoice(questionNumber, isNew) {
  choiceRollover += 1;

  var newChoiceDiv = "";
  newChoiceDiv += "<div id=\"question-" + questionNumber + "-choice-new-" + choiceRollover + "\">";
  newChoiceDiv += "<input name=\"" + questionNumber + "\" type=\"radio\"/>";
  newChoiceDiv += "<input type=\"text\"/>";
  newChoiceDiv += "<input class=\"btn btn-danger\" type=\"button\" value=\"Delete Choice\" " +
    "onclick=\"deleteChoice(" + questionNumber + ", " + choiceRollover + ", true);\"/>";
  newChoiceDiv += "<br /></div>";

  if (isNew) {
    $("#question-new-" + questionNumber + "-add-choice-button").before(newChoiceDiv);
  } else {
    $("#question-" + questionNumber + "-add-choice-button").before(newChoiceDiv);
  }
}

function deleteQuestion(questionNumber, isNew) {
  if (isNew) {
    $("#question-new-" + questionNumber).remove();
  } else {
    $("#question-" + questionNumber).remove();
  }
}

function deleteChoice(questionNumber, choiceNumber, isNew) {
  if (isNew) {
    $("#question-" + questionNumber + "-choice-new-" + choiceNumber).remove();
  } else {
    $("#question-" + questionNumber + "-choice-" + choiceNumber).remove();
  }
}

$(function() {
  if ($("#course_question_json").length > 0 &&
      $("#course-question-editor").length > 0) {
    var editor = $("#course-question-editor");
    var jsonField = $("#course_question_json");
    jsonField.hide();
    editor.show();

    // Deserialize existing questions and display them - also set view up
    var jsonString = jsonField.val() || '{\"questions\":[], \"answers\":[]}';
    var json = JSON.parse(jsonString);
    console.log(jsonString);

    // For each existing question
    for (var i = 0; i < json["questions"].length; i++) {
      var question = (json["questions"][i]);

      // Beginning of Question Div (fieldset) + Title
      var newElement = "<fieldset id=\"question-" + i + "\">";
          newElement += "<input type=\"text\" value=\"" + question.title + "\"/>";
          newElement += "<input class=\"pull-right btn btn-danger\" type=\"button\" value=\"Delete Question\" " +
                          "onclick=\"deleteQuestion(" + i + ");\"/>";

      // Each Choice of the Question
      for (var j = 0; j < question.choices.length; j++) {
        newElement += "<div id=\"question-" + i + "-choice-" + j + "\">";
          newElement += "<input name=\"" + i + "\" type=\"radio\"/>";
          newElement += "<input type=\"text\" value=\"" + question.choices[j] + "\"/>";
          newElement += "<input class=\"btn btn-danger\" type=\"button\" value=\"Delete Choice\" " +
                          "onclick=\"deleteChoice(" + i + ", " + j + ");\"/>";
          newElement += "<br />";
        newElement += "</div>";
      }

      // The Add Choice Button and End of the Question HTML
        newElement += "<input id=\"question-" + i + "-add-choice-button\" class=\"btn btn-primary\"" +
                       "type=\"button\" value=\"Add Choice\" " +
                       "onclick=\"addChoice(" + i + ");\"/>";
      newElement += "</fieldset>";

      // Place in the DOM
      editor.append(newElement);
    }

    // Check the correct answer
    for (var question = 0; question < json["answers"].length; question++) {
      var choice = json["answers"][question];
      var domId = "#question-" + question + "-choice-" + choice;

      $(domId).children("input:radio").prop("checked", true);
    }

    // Submit Hook
    var submitFormCb = function(e) {
      // Handle striping of the Youtube IDs
      $("#youtube-ids").children("div").each(function(i, domObj) {
        $(domObj).children("input:text").each(function(i, domObj) {
          $(domObj).val(getYoutubeIdFromUrl($(domObj).val()));
        });
      });

      // Now the serialization on Questions
      var json = {
        questions: [],
        answers: []
      };

      editor.children().each(function(i, domObj) {
        var thisElement = $(this);
        var elementId = thisElement.attr('id');
        var question = {
          title: "",
          choices: []
        };


        // Only care about the question divs data - not the buttons
        if (RegExp('^question-(new-)*(\\d+)$').test(elementId)) {
          // Data from the question DOM element - iterate over children of div
          thisElement.children().each(function(childOfDivIndex, domObj) {
            var questionDomObj = $(this);
            var isQChoice = RegExp('^question-(\\d+)-choice-(new-)*(\\d+)$')

            // This child element is a multiple choice option
            if (isQChoice.test(questionDomObj.attr('id'))) {
              questionDomObj.children(":input").each(function(i, domObj) {
                var input = $(this);

                // This is the radio box - is this the correct answer?
                if (input[0].type === "radio") {
                  if (input.is(":checked")) {
                    json.answers.push(childOfDivIndex - 2);
                  }
                }
                // This is the actual text of the choice
                else if (input[0].type === "text") {
                  question.choices.push(input.val());
                }
              });
            }
            // This is the title of the Question
            else if (questionDomObj.is("input:text")) {
              question.title = questionDomObj.val();
            }
          });

          // The question data is formed lets append it
          json.questions.push(question);
        }
      });

      // Set the textfield to have the generated JSON and let the server save it
      jsonField.val(JSON.stringify(json));
    };

    $("form").submit(submitFormCb);
  }
});

