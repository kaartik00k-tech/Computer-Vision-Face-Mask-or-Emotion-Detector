function tests=testVisionPipeline
tests=functiontests(localfunctions);
end
function testMissingEmotionModel(testCase)
verifyError(testCase,@() classifyEmotion(uint8(zeros(224,224,3)),[],.6),'VisionGuard:MissingEmotionModel');
end
function testMissingMaskModel(testCase)
verifyError(testCase,@() detectFaceMask(uint8(zeros(224,224,3)),[],.6),'VisionGuard:MissingMaskModel');
end
function testInvalidFrame(testCase)
verifyError(testCase,@() detectFaces([],[]),'VisionGuard:InvalidFrame');
end
