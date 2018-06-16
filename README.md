# hubot-fass-reservation

[![CircleCI][circleci-image]][circleci-url]
[![npm version][npm-image]][npm-url]
[![License][license-image]][license-url]

A Hubot script for utilities of [FaSS](http://www.fasssalon.com/) reservation.

See [`src/fass-reservation.coffee`](src/fass-reservation.coffee) for full documentation.

## Installation

In hubot project repo, run:

```sh
yarn add hubot-fass-reservation

# or

npm install hubot-fass-reservation
```

Then add **hubot-fass-reservation** to your `external-scripts.json`:

```json
[
  "hubot-fass-reservation"
]
```

## Usage

### List salon

```sh
> hubot fass list

FaSS有楽町マルイ店 - yurakuchomarui
  e.g., `hubot fass yurakuchomarui w`

FaSS八重洲地下街店 - yaesuchikagai
  e.g., `hubot fass yaesuchikagai w`

FaSS中目黒店 - nakameguro
  e.g., `hubot fass nakameguro w`

FaSS二子玉川ライズS.C.店 - futakotamagawarisesc
  e.g., `hubot fass futakotamagawarisesc w`

FaSS新宿マルイ本館店 - shinjukumaruihonkan
  e.g., `hubot fass shinjukumaruihonkan w`

FaSSアトレヴィ大塚店 - atrevieotsuka
  e.g., `hubot fass atrevieotsuka w`

FaSS三軒茶屋店 - sangenjaya
  e.g., `hubot fass sangenjaya w`

FaSS下北沢店 - shimokitazawa
  e.g., `hubot fass shimokitazawa w`

FaSS代官山アドレス・ディセ店 - daikanyama17
  e.g., `hubot fass daikanyama17 w`

FaSS横浜ビブレ店 - yokohamavivre
  e.g., `hubot fass yokohamavivre w`

FaSSアトレ川崎店 - atrekawasaki
  e.g., `hubot fass atrekawasaki w`
```

```sh
> hubot fass futakotamagawarisesc w

ＦａＳＳニ子玉川ライズＳ．Ｃ．店
 ・待ち人数：6人
 ・待ち時間の目安：40 ～ 50分
 　01) 207
 　02) 208
 　03) 209
 　04) 210
 　05) 212
 　06) 213
```

## License

[MIT][license-url]

© sugarshin

[npm-image]: https://img.shields.io/npm/v/hubot-fass-reservation.svg?style=flat-square
[npm-url]: https://www.npmjs.com/package/hubot-fass-reservation
[circleci-image]: https://circleci.com/gh/sugarshin/hubot-fass-reservation.svg?style=svg&circle-token=6f9e2532611d1ccb5de385903a2c0a9029f6427e
[circleci-url]: https://circleci.com/gh/sugarshin/hubot-fass-reservation
[license-image]: https://img.shields.io/:license-mit-blue.svg?style=flat-square
[license-url]: https://sugarshin.mit-license.org/
