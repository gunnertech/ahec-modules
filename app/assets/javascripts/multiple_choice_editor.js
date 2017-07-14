// Probably the ugliest code I have ever written, but no need to add Backbone
// for 1 small part of the entire app, and I don't want each button press to 
// refrsh the page...

function getYoutubeIdFromUrl(url){
  var regExp = /^.*((youtu.be\/)|(v\/)|(\/u\/\w\/)|(embed\/)|(watch\?))\??v?=?([^#\&\?]*).*/;
  var match = url.match(regExp);
  return (match&&match[7].length==11)? match[7] : url;
}

var QuizRollover = {
  question: 0,
  choice: 0
};

var SurveyRollover = {
  question: 0,
  choice: 0
};

// My stupid way of implementing pointers in JS quickly... Stupid I know.
function addQuestion(whichQuestions) {
  if (whichQuestions === "survey-question") {
    addQuestion_impl(whichQuestions, QuizRollover);
  } else if (whichQuestions === "course-question") {
    addQuestion_impl(whichQuestions, SurveyRollover);
  }
}

function addChoice(whichQuestions, questionNumber) {
  if (whichQuestions === "survey-question") {
    addChoice_impl(whichQuestions, QuizRollover, questionNumber, isNew);
  } else if (whichQuestions === "course-question") {
    addChoice_impl(whichQuestions, SurveyRollover, questionNumber, isNew);
  }
}

function addQuestion_impl(whichQuestions, questionRollover) {
  questionRollover.question += 1;

  var newQuestion = "<fieldset id=\"" + whichQuestions + "-new-" + questionRollover.question + "\">";
  newQuestion += "<input type=\"text\"/>";
  newQuestion += "<input class=\"btn pull-right btn-danger\" type=\"button\" value=\"Delete Question\" " +
    "onclick=\"deleteQuestion(\'" + whichQuestions + "\', " + questionRollover.question + ", true);\"/>";

  if (whichQuestions === "course-question") {
  newQuestion += "<input class=\"btn btn-primary\" id=\"" + whichQuestions + "-new-" + questionRollover.question + "-add-choice-button\" type=\"button\" value=\"Add Choice\" " +
        "onclick=\"addChoice(\'" + whichQuestions + "\', " + questionRollover.question + ");\"/>";
  }

  newQuestion += "</fieldset>";

  $("#" + whichQuestions + "-editor").append(newQuestion);
}

function addChoice_impl(whichQuestions, questionRollover, questionNumber, isNew) {
  questionRollover.choice += 1;

  var newChoiceDiv = "<div id=\"" + whichQuestions + "-" + questionNumber + "-choice-new-" + questionRollover.choice + "\">";
  newChoiceDiv += "<input name=\"" + questionNumber + "\" type=\"radio\"/>";
  newChoiceDiv += "<input type=\"text\"/>";
  newChoiceDiv += "<input class=\"btn btn-danger\" type=\"button\" value=\"Delete Choice\" " +
    "onclick=\"deleteChoice(\'" + whichQuestions + "\', " + questionNumber + ", " + questionRollover.choice + ", true);\"/>";
  newChoiceDiv += "<br /></div>";

  if (isNew) {
    $("#" + whichQuestions + "-new-" + questionNumber + "-add-choice-button").before(newChoiceDiv);
  } else {
    $("#" + whichQuestions + "-" + questionNumber + "-add-choice-button").before(newChoiceDiv);
  }
}

function deleteQuestion(whichQuestions, questionNumber, isNew) {
  if (isNew) {
    $("#" + whichQuestions + "-new-" + questionNumber).remove();
  } else {
    $("#" + whichQuestions + "-" + questionNumber).remove();
  }
}


function deleteChoice(whichQuestions, questionNumber, choiceNumber, isNew) {
  if (isNew) {
    $("#" + whichQuestions + "-" + questionNumber + "-choice-new-" + choiceNumber).remove();
  } else {
    $("#" + whichQuestions + "-" + questionNumber + "-choice-" + choiceNumber).remove();
  }
}


$(function() {
  if (($("#course_question_json").length > 0 &&
      $("#course-question-editor").length > 0) 
     ||
     ($("#special_questions_json").length > 0 &&
      $("survey-question-editor").length > 0)) {

    /////////////////////
    // Setup the views //
    /////////////////////

    // Course Init & Hide
    var courseEditor = $("#course-question-editor");
    var courseJsonField = $("#course_question_json");
    courseJsonField.hide();
    courseEditor.show();

    // Survey Init & Hide
    var surveyEditor = $("#survey-question-editor");
    var surveyJsonField = $("#course_special_questions");
    surveyJsonField.hide();
    surveyEditor.show();

    // Parse Json
    var courseJsonData = JSON.parse(courseJsonField.val() || '{\"questions\":[], \"answers\":[]}');
    var surveyJsonData = JSON.parse(surveyJsonField.val() || '[\"Opinions?\"]');

    // Course = For each existing question, render them into the view
    for (var i = 0; i < courseJsonData["questions"].length; i++) {
      var question = (courseJsonData["questions"][i]);

      // Beginning of Question Div (fieldset) + Title
      var newElement = "<fieldset id=\"course-question-" + i + "\">";
          newElement += "<input type=\"text\" value=\"" + question.title + "\"/>";
          newElement += "<input class=\"pull-right btn btn-danger\" type=\"button\" value=\"Delete Question\" " +
                          "onclick=\"deleteQuestion(\'course-question\', " + i + ", 0);\"/>";

      // Each Choice of the Question
      for (var j = 0; j < question.choices.length; j++) {
        newElement += "<div id=\"course-question-" + i + "-choice-" + j + "\">";
          newElement += "<input name=\"" + i + "\" type=\"radio\"/>";
          newElement += "<input type=\"text\" value=\"" + question.choices[j] + "\"/>";
          newElement += "<input class=\"btn btn-danger\" type=\"button\" value=\"Delete Choice\" " +
                          "onclick=\"deleteChoice(\'course-question\', " + i + ", " + j + ", 0);\"/>";
          newElement += "<br />";
        newElement += "</div>";
      }

      // The Add Choice Button and End of the Question HTML
        newElement += "<input id=\"course-question-" + i + "-add-choice-button\" class=\"btn btn-primary\"" +
                       "type=\"button\" value=\"Add Choice\" " +
                       "onclick=\"addChoice(\'course-question\', " + i + ");\"/>";
      newElement += "</fieldset>";

      // Place in the DOM
      courseEditor.append(newElement);
    }

    // Checkmark the correct answer
    for (var question = 0; question < courseJsonData["answers"].length; question++) {
      var choice = courseJsonData["answers"][question];
      var domId = "#course-question-" + question + "-choice-" + choice;

      $(domId).children("input:radio").prop("checked", true);
    }

    // Now we repeat the process for Survey Questions
    for (var i = 0; i < surveyJsonData.length; i++) {
      var question = (surveyJsonData[i]);

      // Beginning of Question Div (fieldset) + Title
      var newElement = "<fieldset id=\"survey-question-" + i + "\">";
          newElement += "<input type=\"text\" value=\"" + question + "\"/>";
          newElement += "<input class=\"pull-right btn btn-danger\" type=\"button\" value=\"Delete Question\" " +
                          "onclick=\"deleteQuestion(\'survey-question\', " + i + ", 0);\"/>";

      // Place in the DOM
      surveyEditor.append(newElement);
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
      var newCourseJson = {
        questions: [],
        answers: []
      };

      courseEditor.children().each(function(i, domObj) {
        var thisElement = $(this);
        var elementId = thisElement.attr('id');
        var question = {
          title: "",
          choices: []
        };

        // Only care about the question divs data - not the buttons
        if (RegExp('^course-question-(new-)*(\\d+)$').test(elementId)) {
          // Data from the question DOM element - iterate over children of div
          thisElement.children().each(function(childOfDivIndex, domObj) {
            var questionDomObj = $(this);
            var isQChoice = RegExp('^course-question-(\\d+)-choice-(new-)*(\\d+)$')

            // This child element is a multiple choice option
            if (isQChoice.test(questionDomObj.attr('id'))) {
              questionDomObj.children(":input").each(function(i, domObj) {
                var input = $(this);

                // This is the radio box - is this the correct answer?
                if (input[0].type === "radio") {
                  if (input.is(":checked")) {
                    newCourseJson.answers.push(childOfDivIndex - 2);
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
          newCourseJson.questions.push(question);
        }
      });

      // Set the textfield to have the generated JSON and let the server save it
      courseJsonField.val(JSON.stringify(newCourseJson));

      var questionsJson = [];

      surveyEditor.children().each(function(i, domObj) {
        var thisElement = $(this);
        var elementId = thisElement.attr('id');

        // Only care about the question divs data - not the buttons
        if (RegExp('^survey-question-(new-)*(\\d+)$').test(elementId)) {
          // Data from the question DOM element - iterate over children of div
          thisElement.children().each(function(childOfDivIndex, domObj) {
            var questionTitle = $(this);

            // If is the title of the Question
            if (questionTitle.is("input:text")) {
              questionsJson.push(questionTitle.val());
            }
          });
        }
      });


      // Set the textfield to have the generated JSON and let the server save it
      surveyJsonField.val(JSON.stringify(questionsJson));
      console.log(surveyJsonField.val());
    };

    $("form").submit(submitFormCb);
  }
});

$('.quiz-completed-survey').load(function () {
    $(this).height($(this).contents().height());
    $(this).width($(this).contents().width());
});

