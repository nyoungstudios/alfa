final configSchema = {
  'type': 'object',
  'patternProperties': {
    '.*': {
      'type': 'object',
      'properties': {
        'tags': {
          'type': 'array',
          'items': {'type': 'string'}
        },
        'os': {
          'type': 'array',
          'items': {
            'type': 'string',
            'enum': ['macos', 'linux']
          }
        },
        'options': {
          'type': 'array',
          'items': {'type': 'string'}
        },
        'env': {'type': 'object'}
      }
    }
  }
};
