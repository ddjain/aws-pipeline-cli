class AwsCodepipelineCli < Formula
    desc "Interactive terminal utility to view and trigger AWS CodePipeline pipelines"
    homepage "https://github.com/ddjain/aws-pipeline-cli"
    url "https://github.com/ddjain/aws-pipeline-cli/raw/main/aws-pipeline-cli.sh"
    version "1.0.0"
    sha256 "6ee7e13894e2e2bfb3d671440cc5ee8b82738c97ab212843bb18d1082b9e0f95" # Replace with actual sha256 of the script
    license "MIT"
  
    def install
      bin.install "aws-pipeline-cli.sh" => "aws-codepipeline-cli"
    end
  end
