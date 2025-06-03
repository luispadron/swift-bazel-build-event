# swift-bazel-build-event

A Swift library for encoding and decoding Bazel Build Event Protocol (BEP) messages using [SwiftProtobuf](https://github.com/apple/swift-protobuf).

## Installation

```swift
dependencies: [
    .package(url: "https://github.com/luispadron/swift-bazel-build-event", from: "x.x.x"),
]
```

## Usage

```swift
import BazelBuildEvent

// `bazel build ... --build_event_json_file=...`
let njson = """
{...}
{...}
"""

//
// Example loading JSON
//

let buildEventsFromJSON = try njson
    .split(separator: "\n")
    .map { try BuildEvent(jsonString: String($0)) }

//
// Example loading binary
//

var buildEventsFromBinary: [BuildEventStream_BuildEvent] = []
guard let binaryStream = InputStream(url: "/Path/to/binary/bep.binpb") else {
    throw fatalError("Unable to load binary BEP")
}
defer { binaryStream.close() }
binaryStream.open()
while binaryStream.hasBytesAvailable {
    do {
        buildEventsFromBinary.append(
            // This is from SwiftProtobuf and reads a delimited binary file (like the BEP file)
            try BinaryDelimited.parse(
                messageType: BuildEventStream_BuildEvent.self,
                from: binaryStream
            )
        )
    } catch {
        break
    }
}
```

## Development

### Updating BEP proto

```sh
# Clone the bazel repo
gh repo clone bazelbuild/bazel
cd bazel

# Checkout to the version you want to use
git checkout x.x.x

# Compile the protos
protoc \
  --swift_out=/Path/to/repo/swift-bazel-build-event \
  --swift_opt=FileNaming=DropPath \
  --swift_opt=Visibility=Public \
  src/main/java/com/google/devtools/build/lib/buildeventstream/proto/build_event_stream.proto \
  src/main/java/com/google/devtools/build/lib/packages/metrics/package_load_metrics.proto \
  src/main/protobuf/action_cache.proto \
  src/main/protobuf/command_line.proto \
  src/main/protobuf/failure_details.proto \
  src/main/protobuf/invocation_policy.proto \
  src/main/protobuf/strategy_policy.proto \
  src/main/protobuf/option_filters.proto

# Move the generated .pb.swift file to the expected location
cd /Path/to/repo/swift-bazel-build-event
find . -name "*.pb.swift" -exec mv {} Sources/BazelBuildEvent/ \;

# Format the files
swift format . --recursive -i
```
