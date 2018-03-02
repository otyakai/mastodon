# frozen_string_literal: true

module Paperclip
  # This transcoder is only to be used for the MediaAttachment model
  # to check when uploaded videos are actually gifv's
  class VideoTranscoder < Paperclip::Processor
    def make
      meta = ::Av.cli.identify(@file.path)
      attachment.instance.type = MediaAttachment.types[:gifv] unless meta[:audio_encode]
      
      if attachment.instance.file_content_type == 'video/quicktime'
        attachment.instance.file_file_name    = File.basename(attachment.instance.file_file_name, '.*') + '.mp4'
        attachment.instance.file_content_type = 'video/mp4'
      end

      Paperclip::Transcoder.make(file, options, attachment)
    end
  end
end
